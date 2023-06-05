# ------------------- Librerías usadas -------------------
from pymavlink import mavutil
from pymavlink import mavwp
import time
import sys
import os
# Imports for attitude
from pymavlink.quaternion import QuaternionBase
import math
# Imports for I/O
import json
import csv


# ------------------------------------------------------------------
# ------------------- Funciones de Conectividad -------------------- 
# ------------------------------------------------------------------
'''
    Habilita la configuración de parámetros, dónde value es Kp
'''
def ROV_setParam(value):
    master.mav.param_set_send(
        master.target_system, master.target_component,
        b'PSC_POSZ_P',
        value,
        mavutil.mavlink.MAV_PARAM_TYPE_REAL32
    )
    time.sleep(0.01)

'''
    Igual que su predecesor
    Permite al ROV recibir peticiones de lectura
'''
def ROV_setSend():
    master.mav.param_request_read_send(
        master.target_system, master.target_component,
        b'PSC_POSZ_P',
        1
    )
    time.sleep(0.01)

'''
    OnOff == 0 -> se llama a 'disarm'. En caso contrario, a 'arm'.
    Si se trata de desarmar, esperará a la confirmación de su realización.
'''
def ROV_setArmDisarm(OnOff):
    if OnOff == 0: # Disarm
        master.mav.command_long_send(
            master.target_system,
            master.target_component,
            mavutil.mavlink.MAV_CMD_COMPONENT_ARM_DISARM,
            0,
            0, 0, 0, 0, 0, 0, 0
        )
        master.motors_disarmed_wait()
    else: # Arm
        master.mav.command_long_send(
            master.target_system, master.target_component,
            mavutil.mavlink.MAV_CMD_COMPONENT_ARM_DISARM,
            0,
            1, 0, 0, 0, 0, 0, 0
        )

'''
    Envía una señal para modificar la posición del eje z a la indicada en 'depth'. 
'''
def ROV_setDepth(depth):
    master.mav.set_position_target_global_int_send(
        int(1e3 * (time.time() - boot_time)),                   # ms since boot
        master.target_system, master.target_component,          # ROV's signature
        mavutil.mavlink.MAV_FRAME_GLOBAL_INT,                   # Coordinate frame
        (                                                       # Mask which ignores everything except z position
            mavutil.mavlink.POSITION_TARGET_TYPEMASK_X_IGNORE |
            mavutil.mavlink.POSITION_TARGET_TYPEMASK_Y_IGNORE |
            mavutil.mavlink.POSITION_TARGET_TYPEMASK_VX_IGNORE |
            mavutil.mavlink.POSITION_TARGET_TYPEMASK_VY_IGNORE |
            mavutil.mavlink.POSITION_TARGET_TYPEMASK_VZ_IGNORE |
            mavutil.mavlink.POSITION_TARGET_TYPEMASK_AX_IGNORE |
            mavutil.mavlink.POSITION_TARGET_TYPEMASK_AY_IGNORE |
            mavutil.mavlink.POSITION_TARGET_TYPEMASK_AZ_IGNORE |
            mavutil.mavlink.POSITION_TARGET_TYPEMASK_YAW_IGNORE |
            mavutil.mavlink.POSITION_TARGET_TYPEMASK_YAW_RATE_IGNORE
        ), 
        0, 0, depth,                                            # (x, y WGS84 frame pos - not used), z [m].  lat_int, lon_int, alt
        0, 0, 0,                                                # velocities in NED frame [m/s] (not used, vx, vy, vz)
        0, 0, 0, 0, 0                                           # afx, afy, afz, yaw, yaw_ra
        # accelerations in NED frame [N], yaw, yaw_rate
        #  (all not supported yet, ignored in GCS Mavlink)
    )

""" 
    Sets the target attitude while in depth-hold mode.
    'roll', 'pitch', and 'yaw' are angles in degrees.
"""
def ROV_setAttitude(roll, pitch, yaw):
    master.mav.set_attitude_target_send(
        int(1e3 * (time.time() - boot_time)),           # ms since boot
        master.target_system, master.target_component,  # ROV's signature
        mavutil.mavlink.ATTITUDE_TARGET_TYPEMASK_THROTTLE_IGNORE, # allows throttle to be controlled by depth_hold mode
        # -> attitude quaternion (w, x, y, z | zero-rotation is 1, 0, 0, 0)
        QuaternionBase([math.radians(angle) for angle in (roll, pitch, yaw)]),
        0, 0, 0, 0 # roll rate, pitch rate, yaw rate, thrust
    )

'''
    Activa el modo de operación indicado en la variable 'MODE'.
'''
def ROV_setOperatingMode():
    DEPTH_HOLD_MODE = master.mode_mapping()[MODE]
    while not master.wait_heartbeat().custom_mode == DEPTH_HOLD_MODE:
        master.set_mode(MODE)

'''
    Hace la escucha de todos los parámetros indicados en ROV_paramValues, de
    modo secuencial, en el orden que estén declarados en ROV_paramNames
'''
def ROV_listenParameters():
    global ROV_nData
    cont = 0
    ROV_nData = ROV_nData + 1
    for name in ROV_paramNames:
        ROV_message = master.recv_match(None, name, True, 0.1)
        if not ROV_message:
            ROV_paramValues[cont].append(json.loads('{"error" : "nan"}'))
        else:
            ROV_paramValues[cont].append(message_toJSON(ROV_message, name))
        cont = cont + 1

'''
    Escucha mensajes provenientes del ROV durante 't_tomaDatos' segundos (actualmente, 30s)
'''
def ROV_listenPArameters_Paralelo(filename):
    t = time.time()
    with open(filename, 'w') as f:
        while time.time() < t + t_tomaDatos:
            msg = master.recv_match(blocking=True)
            if msg:
                if msg.get_type() == 'SYSTEM_TIME':
                    # Formatear el mensaje de System Time
                    system_time_msg = "SYSTEM_TIME message received: time_unix_usec=%f, time_boot_ms=%f" % (msg.time_unix_usec, msg.time_boot_ms)
                    #print(system_time_msg)
                    f.write(system_time_msg + '\n')
                if msg.get_type() == 'ATTITUDE':
                    # Formatear el mensaje de actitud
                    attitude_msg = "ATTITUDE message received: roll=%f, pitch=%f, yaw=%f, rollspeed=%f, pitchspeed=%f, yawspeed=%f" % (msg.roll, msg.pitch, msg.yaw, msg.rollspeed, msg.pitchspeed, msg.yawspeed)
                    #print(attitude_msg)
                    f.write(attitude_msg + '\n')
                if msg.get_type() == 'SCALED_PRESSURE':
                    # Formatear el mensaje de presión escalada
                    pressure_msg = "SCALED_PRESSURE message received: pressure=%f, temperature=%f" % (msg.press_abs, msg.temperature)
                    #print(pressure_msg)
                    f.write(pressure_msg + '\n')
                if msg.get_type() == 'SCALED_IMU2':
                    # Formatear el mensaje de Scaled imu2
                    scaledimu2_msg = "SCALED IMU2 message received: xacc=%f, yacc=%f, zacc=%f, xgyro=%f, ygyro=%f, zgyro=%f, xmag=%f, ymag=%f, zmag=%f, temperature=%f" % (msg.xacc, msg.yacc, msg.zacc, msg.xgyro, msg.ygyro, msg.zgyro, msg.xmag, msg.ymag, msg.zmag, msg.temperature)
                    #print(scaledimu2_msg)
                    f.write(scaledimu2_msg + '\n')
                if msg.get_type() == 'GLOBAL_POSITION_INT':
                    # Formatear el mensaje de Scaled imu2
                    globalpositionint = "GLOBAL POSITION INT message received: lat=%f, lon=%f, alt=%f, relative_alt=%f, vx=%f, vy=%f, vz=%f, hdg=%f" % (msg.lat, msg.lon, msg.alt, msg.relative_alt, msg.vx, msg.vy, msg.vz, msg.hdg)
                    #print(globalpositionint)
                    f.write(globalpositionint + '\n')
                if msg.get_type() == 'NAV_CONTROLLER_OUTPUT':
                    # Formatear el mensaje de Scaled imu2
                    navcontrolleroutput_msg = "NAV CONTROLLER OUTPUT message received: nav_roll=%f, nav_pitch=%f, nav_bearing=%f, target_bearing=%f, wp_dist=%f, alt_error=%f, aspd_error=%f, xtrack_error=%f" % (msg.nav_roll, msg.nav_pitch, msg.nav_bearing, msg.target_bearing, msg.wp_dist, msg.alt_error, msg.aspd_error, msg.xtrack_error)
                    #print(navcontrolleroutput_msg)
                    f.write(navcontrolleroutput_msg + '\n')
                elif msg.get_type() == 'EKF_STATUS_REPORT':
                    # Formatear el mensaje de Scaled imu2
                    ekf_msg = "EKF STATUS REPORT message received: flags=%f, velocity_variance=%f, pos_horiz_variance=%f, pos_vert_variance=%f, compass_variance=%f,  terrain_alt_variance=%f, airspeed_variance=%f" % (msg.flags, msg.velocity_variance, msg.pos_horiz_variance, msg.pos_vert_variance, msg.compass_variance,  msg.terrain_alt_variance, msg.airspeed_variance)
                    #print(ekf_msg)
                    f.write(ekf_msg + '\n')

# ------------------------------------------------------------------
# ------------------- Funciones de Input/Output --------------------
# ------------------------------------------------------------------

'''
    ROV message => JSON format (source is an addition to the key to know the variable)
'''
def message_toJSON(x, source):
    x = str(x)
    lista = x.split(" ")
    x = ' '.join(lista[1:len(lista)])
    x = x.replace("{", '{"' + source + "_")
    x = x.replace(", ", ',"' + source + "_")
    x = x.replace(" :", '":')
    return json.loads(x)

'''
    Guarda algunos campos en un fichero txt llamado 'file"VALUE".txt'.
    'Value' representa a Kp
'''
def data_toTXT(value):
    file = open('G:/Mi unidad/00_tesis/ucaROV/UCAROV_03/UCAROV_03/file'+str(value)+'.txt', "w")
    file.write(ensayo + "\n" + str(value) + "\nDEPTH\n" + str(depth) + "\nROLL\n" + str(roll) + "\nPITCH\n" + str(pitch) + "\nYAW\n" + str(yaw))
    file.close()

'''
    Guarda en 'ofile_"VALUE".csv' los datos de ROV_paramValues.
    'Value' representa a Kp. No usado con los nuevos sistemas de I/O
'''
def data_toCSV(value):
    file = open('ofile_'+str(value)+'.csv', "w")
    file.write(','.join(ROV_paramValues) + "\n")
    file.close()

'''
    Escribe en csv de manera más eficaz, usando el formato de Json
'''
def mergeJSON(A, B):
    return {**A, **B}

def data_toCSV2(filename):
    title = []
    cont = 0
    # --------- Obtenemos el nombre de las variables ---------
    while cont < ROV_nParams:
        for k in ROV_paramValues[cont][0]:
            title.append(k)
        cont = cont + 1

    title = ','.join(title)
    # ---------------------------------------------------------

    with open(filename, "w", newline="") as f: # Abrimos el fichero donde guardar los datos
        cw = csv.writer(f, delimiter=',', quoting=csv.QUOTE_MINIMAL)
        f.write(title + "\n") # Escribimos el título
        muestra = 0
        while muestra < ROV_nData:
            data = ROV_paramValues[0][muestra] # Vamos a guardar en data todas las caracteristicas de la muestra 'i'
            carac = 1
            while carac < ROV_nParams: # Concatenamos todos los JSON en data
                data = mergeJSON(data, ROV_paramValues[carac][muestra])
                carac = carac + 1
            cw.writerow(data.values()) # Finalmente escribimos los valores en el fichero,
            muestra = muestra + 1  # y pasamos a la siguiente muestra
        


# ------------------------------------------------------------------
# ------------------- Funciones sobre Enrutado --------------------- 
# ------------------------------------------------------------------
# WIP ~> Falta la implementación de PolyGenesis para completar el enrutado

'''
    Places the waypoints of a given mission in order. It needs the ROV's and flow's speed of movement  
'''
def mission_realisticMap(filename_Map, velocity, flow):
    Vx = []
    Vy = []
    file = open(filename_Map, "r")
    for string in file:
        args = string.split("\t")
        Vx.append(args[8])
        Vy.append(args[9])
    file.close()


'''
    Does the whole protocol to upload a mission
'''
def cmd_set_home(home_location, altitude):
    print('--- ', master.target_system, ',', master.target_component)
    master.mav.command_long_send(
        master.target_system, master.target_component,
        mavutil.mavlink.MAV_CMD_DO_SET_HOME,
        1,  # set position
        0,  # param1
        0,  # param2
        0,  # param3
        0,  # param4
        home_location[0],  # lat
        home_location[1],  # lon
        altitude)

def uploadmission(aFileName):
    home_location = None
    home_altitude = None

    with open(aFileName) as f:
        for i, line in enumerate(f):
            if i == 0:
                if not line.startswith('QGC WPL 110'):
                    raise Exception('File is not supported WP version')
            else:
                linearray = line.split('\t')
                ln_seq = int(linearray[0])
                ln_current = int(linearray[1])
                ln_frame = int(linearray[2])
                ln_command = int(linearray[3])
                ln_param1 = float(linearray[4])
                ln_param2 = float(linearray[5])
                ln_param3 = float(linearray[6])
                ln_param4 = float(linearray[7])
                ln_x = float(linearray[8])
                ln_y = float(linearray[9])
                ln_z = float(linearray[10])

                #ln_autocontinue = float(linearray[11].strip())
                ln_autocontinue = int(float(linearray[11].strip()))
                if (i == 1):
                    home_location = (ln_x, ln_y)
                    home_altitude = ln_z
                p = mavutil.mavlink.MAVLink_mission_item_message(master.target_system, master.target_component, ln_seq,
                                                                 ln_frame,
                                                                 ln_command,
                                                                 ln_current, ln_autocontinue, ln_param1, ln_param2,
                                                                 ln_param3, ln_param4, ln_x, ln_y, ln_z)
                wp.add(p)

    cmd_set_home(home_location, home_altitude)
    msg = master.recv_match(type=['COMMAND_ACK'], blocking=True)
    print(msg)
    print('Set home location: {0} {1}'.format(home_location[0], home_location[1]))
    time.sleep(1)

    # send waypoint to airframe
    master.waypoint_clear_all_send()
    master.waypoint_count_send(wp.count())

    for i in range(wp.count()):
        msg = master.recv_match(type=['MISSION_REQUEST'], blocking=True)
        print(msg)
        master.mav.send(wp.wp(msg.seq))
        print('Sending waypoint {0}'.format(msg.seq))

'''
    Starts the mission protocol
    https://mavlink.io/en/services/mission.html
    https://mavlink.io/en/file_formats/#mission_plain_text_file
    https://www.youtube.com/watch?v=0d23O_RUOmI   Lo hace con QGroundControl
    https://www.youtube.com/watch?v=rui2Trps2yc   Aqui se ve bien la estructura de la misión

     Función para ver el estado de la batería, y si está por debajo de 12.5V, levantar una flag y devolverlo a la zona de embarcamiento
    de inmediato? https://www.ardusub.com/quick-start/first-dive.html

    Los comandos relacionados con las misiones están en MAV_CMD (cada uno con sus parámetros diferentes) https://ardupilot.org/copter/docs/common-mavlink-mission-command-messages-mav_cmd.html
    Y el ROV puede mandar mensajes en ciertas ocasiones https://mavlink.io/en/messages/common.html#MISSION_ITEM_REACHED
'''


# ------------------------------------------------------------------
# -------------------------- Initial Data --------------------------
# ------------------------------------------------------------------
# master = mavutil.mavlink_connection('udpin:0.0.0.0:14550') # Conexión ROV
master = mavutil.mavlink_connection('udpin:localhost:14551') # Conexión SITL
master.wait_heartbeat() # esperamos a que haga conexión
boot_time = time.time()
wp = mavwp.MAVWPLoader() # necesario para las misiones

# Kp = [0, 3] # valor de kp definición del ensayo
# Kp = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] # valor de kp definición del ensayo
Kp = [1, 2] # valor de kp 
t_tomaDatos = 30 # tiempo de toma de datos del ROV [segundos]
ROV_nParams = 7
ROV_nData = 0
ROV_paramNames = ["SYSTEM_TIME", "ATTITUDE", "SCALED_PRESSURE", "SCALED_IMU2", "GLOBAL_POSITION_INT", "NAV_CONTROLLER_OUTPUT", "EKF_STATUS_REPORT"]
ROV_paramValues = [[], [], [], [], [], [], []] # ROV_pV[caracteristica][n_muestra]
ensayo = 'DEPTH P GAIN '
MODE = 'ALT_HOLD'
depth = -5 
roll = 0
pitch = 0
yaw = 0


# ---------------------------------------------------
# -------------- Main course of action --------------
# ---------------------------------------------------

if __name__ == "__main__":
    
    for v in Kp:
        ROV_setSend()
        ROV_setParam(v)
        ROV_setOperatingMode() # Colocamos el modo de operación
        ROV_setArmDisarm(1)    # Armamos el ROV
        
        ROV_listenPArameters_Paralelo('ofile' + str(v) + '.txt')

        ROV_setArmDisarm(0) # Desarmamos el ROV
        

'''
if __name__ == "__main__":
    
    for v in Kp:
        ROV_setSend()
        
        ROV_setParam(v)
        ROV_setOperatingMode() # Colocamos el modo de operación
        ROV_setArmDisarm(1)    # Armamos el ROV
        
        timeout_start = time.time()
        while time.time() < timeout_start + t_tomaDatos:
            ROV_listenParameters() # Escuchamos sus parámetros

        ROV_setArmDisarm(0) # Desarmamos el ROV
        data_toTXT(v)
        data_toCSV2("resultados.csv")
        print(str(len(ROV_paramValues)) + str(ROV_nData))

'''