import cadquery as cq

# Medidas padrão
DIAMETRO_EXTERNO = 38  # mm
ALTURA_TOTAL = 110     # mm
DIAMETRO_ROSCA = 30    # mm

def criar_acionador(d_ext, altura, d_rosca):
    corpo_externo = cq.Workplane("XY").circle(d_ext / 2).extrude(altura)
    furo_interno = cq.Workplane("XY").circle(d_rosca / 2).extrude(altura)
    modelo_final = corpo_externo.cut(furo_interno)
    return modelo_final

# Gerar modelo
modelo = criar_acionador(DIAMETRO_EXTERNO, ALTURA_TOTAL, DIAMETRO_ROSCA)
show_object(modelo)

