# Robyn: Marketing Mix Modeling by Facebook

Sintiendo el sabor de Robyn

Pasos:

1. Crear carpeta poe_project
2. Ingresar carpeta
3. Crear ambiente virutal python
4. Activar ambiente virtual
5. Actualizar pip
6. Actualizar setuptools
7. Instalar poetry
8. Crear proyecto con poetry poetry new robyn-demo
9. Ingresar al proyecto robyn-demo
10. Correr R -e 'librar(renv)'
11. Correr R -e 'renv::init()'
12. Correr R -e 'install.packages("remotes")'
13. Insatalr h2o R -e 'install.packages("h2o")'
13. Correr R -e 'remotes::install_github("facebookexperimental/Robyn/R")'
14. Verificar version R -e 'packageVersion("Robyn")'
15. Al usar renv e instalar h2o y Robyn probablemente se instalará reticulate, verifica con R -e 'packageVersion("reticulate")'. Sino instala con R -e 'install.packages("reticulate")'
16. Instalar nevergrad con poetry add nevergrad
17. Asegurarse que en demo.R se use el ambiente virtual donde se instalo nevergrad `use_virtualenv("path-ambiente-virtual", required = TRUE)`

# Preguntas

- ¿Cómo obtener contribuciones de cada uno de los fuentes/medios [canales]?
- ¿Adstock PDF permite efecto retardado?
- ¿Qué es  adstock?
- ¿Qué es efecto retardado?
- ¿Que es tasa de decaimiento?
- ¿Qué es la distribución de probabilidad Geométrica?
- ¿Qué es la distribución de probabilidad Weibull?
- No entiendo parte de calibración [experimentación]


# Recomendaciones

- prophet_vars: para data diaria usar "trend", "season", "weekday", "holiday". para data semanal o mensual usar "trend", "season", "holiday".
- paid_media_vars: usar métricas de nivel de exposición (impresiones, clicks, GRP, etc) diferentes del gasto.

Vamos en Hiperparámetros.


# Capacidad

robyn_inputs

- date_var:  Soporta datos en unidad de tiempo diaria, semanal y mensual. Formato string "YYYY-MM-DD".
- dep_var_type: "revenue" para calcular ROI o "conversion" para calcular CPI
- Los argumentops con sufijo _signs permite controlar el signo del coeficiente.
- Al usar métricas de nivel de exposición (impresiones, clicks, GRP, etc) se puede calcular ROAS.
- adstock: Adstock: Carácter. Elija cualquiera de "geometric", "weibull_cdf", "weibull_pdf". Weibull adstock es una función de dos paramétricas y, por lo tanto, más flexible, pero lleva más tiempo que la función geométrica tradicional de una paramétrica. CDF, o la función de densidad acumulativa de la función de Weibull, permite cambiar la tasa de decaimiento a lo largo del tiempo en forma de C y S, mientras que el valor máximo siempre permanecerá en el primer período, lo que significa que no hay efecto retardado. PDF, o la función de densidad de probabilidad, permite que el valor máximo se produzca después del primer período cuando la forma >=1, lo que permite un efecto retardado. Ejecute 'plot_adstock()' para ver la diferencia visualmente. Estimación de tiempo: con adstock geométrico, 2000 iteraciones * 5 pruebas en 8 núcleos, se tarda menos de 30 minutos. Ambas opciones de Weibull toman hasta el doble de tiempo.

# Conceptos

- Métricas de niveles de exposición son por ejemplo impresiones, clicks, GRP, etc.
- Variables orgánicas: comparadas con los canales pagos son con frecuencia las actividades de marketing sin gastos claros. Por lo general son envió de boletines, notificaciones push y publicaciones en redes sociales.

# Corriendo rápidamente demo

1. Cargar datos
2. Especificación modelo en 4 pasos. Para usuarios avanzados se puede hacer la especificación en un sólo paso.
 2.1. Especificar variables de entrada
 2.2. Definir y adicionar hiperparámetros
 2.3. Adicionar hiperparámetros a la función robyn_inputs()
3. Construir Modelo Inicial. Se presentó el sgte error:

Error in grid.Call.graphics(C_text, as.graphicsAnnot(x$label), x$x, x$y,  : 
  invalid font type
Calls: <Anonymous> ... drawDetails -> drawDetails.text -> grid.Call.graphics
In addition: There were 50 or more warnings (use warnings() to see the first 50)
Execution halted

El mismo problema se presenta usando MacBookPro, a pesar de eso se evidencia la velocidad de la máquina. MacBookAir 10.52 minutos, MacBookPro 1.52 minutos.