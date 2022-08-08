library(reticulate)

# Create virtualenvironment
# In python would be: 'python3 -m venv pythonvenv'
virtualenv_create("pythonvenv")

# Crea un ambiente virtual de python en el camino
#  '/Users/santiagolondono/.virtualenvs/pythonvenv'

# Otra forma de crear y usar un ambiente virtual sería

# 1. Crear ambiente vitual en consola usando 'python3 -m venv pythonvenv'
# El paso 1 crea carpeta en el proyecto
# 2. En el script correr método: use_virtualenv("path-venv-paso1", required = TRUE)