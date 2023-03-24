
---- Instancias ----
> Están seleccionadas solo las que tienen el formato correcto de coordenadas y
ruta óptima.
> En "COORDENADAS.mat" están las coordenadas de los mapas
> En "RUTAS.mat" las soluciones propuestas en TSPLib
> En "LONGITUDES.mat" los costes reales de las soluciones propuestas en TSPLib


Copiar la intro de PolyGenesis (Las funciones de Topología y esquema general)

Implementar optimización entre dos Caminos Mínimos (Regla de Derivacion)

Implementar unificación del TSP y Conjunto de Caminos Mínimos

Implementar función "Hub" que llama a la unificación y luego a la
optimización para minimizar todo el conjunto
Hay que tener en cuenta que en el hub para que la RdD funcione, uno de
los dos caminos debe de ser vacío. Entonces, cuando un segmento se tenga
que comparar al resto para atraer sus puntos, se usará cada par
consecutivo de puntos (por la RdC son caminos vacíos, soo...)