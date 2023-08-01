# Robyn: Marketing Mix Modeling by Facebook

Sintiendo el sabor de Robyn

Pasos:

- Instalar [Robyn](https://facebookexperimental.github.io/Robyn/docs/quick-start/)
    - Ejecutar en cosola
        1. `R -e "install.packages('remotes')"`
        2. `R -e "remotes::install_github('facebookexperimental/Robyn/R')"`
        3. `R -e "library(Robyn)"`
     
- La librería nevergrad [encargada de realizar la optimización de los hiperparámetros de Robyn] funciona con python 3.9; no funciona correctamente con versiones superiores. Para equipos Mac que tienen versiones de python diferentes, ejecutar en consola
    1. `brew install python@3.9` Omitir si ya tiene instalado python 3.9
    2. `python3.9 -m venv venv` 
    3. `source venv/bin/activate`
    4. `git clone REPO-NAME-URL` Clonar este repositorio.
    5. `pip install -r requirements.txt`

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
Execution halted.


El mismo problema se presenta usando MacBookPro, a pesar de eso se evidencia la velocidad de la máquina. MacBookAir 10.52 minutos, MacBookPro 1.52 minutos.

El problema se genera en las siguientes lineas de código:


```
# Check MOO (multi-objective optimization) convergence plots
OutputModels$convergence$moo_distrb_plot
OutputModels$convergence$moo_cloud_plot
```

El error es:

```
Picking joint bandwidth of 0.0156
Picking joint bandwidth of 0.00297
Error in grid.Call.graphics(C_text, as.graphicsAnnot(x$label), x$x, x$y,  : 
  invalid font type
Calls: <Anonymous> ... drawDetails -> drawDetails.text -> grid.Call.graphics
In addition: There were 50 or more warnings (use warnings() to see the first 50)
Execution halted
```

4. Seleccionar y guardar cualquier modelo

5. Obtener asignación de presupuesto basada en el modelo seleccionado arriba

Un error se genera en:

```
plot(optimal_response$plot)
```

El error es

```
Error in grid.Call.graphics(C_text, as.graphicsAnnot(x$label), x$x, x$y,  : 
  invalid font type
Calls: plot ... drawDetails -> drawDetails.text -> grid.Call.graphics
In addition: There were 50 or more warnings (use warnings() to see the first 50)
Execution halted
```

6. Actualización Modelo basado en modelo seleccionado y resultados guardados alpha

7. Obtener una recomendación de asignación de presupuesto basada en las ejecuciones de actualización seleccionadas

8. Obtener rendimientos marginales

Se presento el siguiente error.

Un error se genera en:

```
Response1$plot
```

El error es

```
Error in grid.Call.graphics(C_text, as.graphicsAnnot(x$label), x$x, x$y,  : 
  invalid font type
Calls: <Anonymous> ... drawDetails -> drawDetails.text -> grid.Call.graphics
In addition: There were 50 or more warnings (use warnings() to see the first 50)
Execution halted
```
Los anteriores errores sucedían porque estaba corriendo el proyecto en Visual Studio Code, si se corre en Rstudio todo los graficos se crearán. Si quieres evitar los errores en Visual Studio Code debes guardar las gráficas. Un ejemplo sería, se guarda la última gráfica del paso 8:

```
jpeg('rplot.jpg')
response_sending$plot
dev.off()
```
