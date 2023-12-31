#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Error: Proporcione el nombre del módulo como argumento."
    exit 1
fi

nombre_modulo_plural=$1
nombre_modulo_singular=$2
nombre_modulo_genero_singular=$3
archivo_put="$nombre_modulo_plural/endpoints/put.py"

{
  cat <<EOF
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from functions.db import get_db
from resources.log.logger import logger
from service.modules.$nombre_modulo_plural.functions.crud import update
from service.modules.$nombre_modulo_plural.views import schemas

router = APIRouter()

@router.put("/", tags=["$nombre_modulo_plural"], status_code=200, response_model=dict)
def put_$nombre_modulo_singular($nombre_modulo_singular: schemas.${nombre_modulo_plural^}Upload, ${nombre_modulo_singular}_id: int, db: Session = Depends(get_db)):
    respuesta = update.update_$nombre_modulo_singular(db, $nombre_modulo_singular, ${nombre_modulo_singular}_id)

    if not respuesta:
        logger.warning(f'No se pudo actualizar $nombre_modulo_genero_singular $nombre_modulo_singular ID {${nombre_modulo_singular}_id} porque no existe')
        raise HTTPException(status_code=404, detail='No se encontro $nombre_modulo_genero_singular $nombre_modulo_singular')

    logger.trace(f'Se modifico $nombre_modulo_genero_singular $nombre_modulo_singular con el id {${nombre_modulo_plural}_id}')
    return {'message': 'Se modifico $nombre_modulo_genero_singular $nombre_modulo_singular'}

EOF
} > "$archivo_put"