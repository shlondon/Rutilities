library(reticulate)

# # Check your python version and configurations
# print(py_config())

# # Create virtualenvironment
# # In python would be: 'python3 -m venv pythonvenv'
# virtualenv_create("pythonvenv")

# Lo anterior crea un ambiente virtual de python en el camino
#  '/Users/MYUSER/.virtualenvs/pythonvenv'

# Otra forma de crear y usar un ambiente virtual sería

# 1. Crear ambiente virtual en consola usando 'python3 -m venv pythonvenv'
# El paso 1 crea carpeta en el proyecto
# 2. En el script correr método: use_virtualenv("path-venv-paso1", required = TRUE)
use_virtualenv("/Users/santiagolondono/Documents/Proyectos/Rutilities/reticulateHW/pyvenv", required = TRUE)
py_config()