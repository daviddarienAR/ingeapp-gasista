-- ================================================================
-- IngeAPP — Migración a tabla unificada preguntas_banco
-- Ejecutar en Supabase SQL Editor
-- ================================================================

-- Eliminar tabla anterior si existe
drop table if exists public.preguntas_extra;

-- Crear tabla unificada
create table if not exists public.preguntas_banco (
  id          text primary key,
  tipo        text not null check (tipo in ('mc','flash','vf','completar')),
  tema        text not null,
  texto       text not null,
  opciones    jsonb,
  correcta    integer,
  respuesta   text,
  explicacion text,
  orden       integer default 0,
  activa      boolean default true,
  created_at  timestamptz default now()
);

-- Seguridad por filas (RLS)
alter table public.preguntas_banco enable row level security;

create policy "Lectura publica preguntas_banco" on public.preguntas_banco
  for select using (true);

create policy "Admin gestiona preguntas_banco" on public.preguntas_banco
  for all using (auth.email() = 'davidotero.darien@gmail.com')
  with check (auth.email() = 'davidotero.darien@gmail.com');

-- ================================================================
-- PREGUNTAS MÚLTIPLE OPCIÓN (48)
-- ================================================================
insert into public.preguntas_banco (id,tipo,tema,texto,opciones,correcta,respuesta,explicacion,orden) values
-- GASES (g1-g12)
('g1','mc','gases','¿Cuál es el principal componente del Gas Natural?','["Propano (C3H8)","Butano (C4H10)","Metano (CH4) en un 95-98%","Hidrógeno"]',2,null,'El Gas Natural está compuesto principalmente por METANO en un 95 a 98%. El metano liberado a la atmósfera es aprox. 16 veces más contaminante que los gases de su combustión.',1),
('g2','mc','gases','¿Cuál es el poder calorífico del Gas Grado 1 (Propano)?','["9.300 Kcal/m³","13.000 Kcal/m³","22.380 Kcal/m³","27.482 Kcal/m³"]',2,null,'El Gas Grado 1 (Propano) tiene un poder calorífico de 22.380 Kcal/m³. El GN tiene ~9.300 Kcal/m³ y el Gas Grado 3 (Butano) tiene 27.482 Kcal/m³.',2),
('g3','mc','gases','¿A qué temperatura pasa a estado líquido el Gas Grado 1 (Propano)?','["-17°C","-44°C","0°C","-100°C"]',1,null,'El Gas Grado 1 (Propano, C3H8) está en estado líquido a -44°C. A temperaturas más altas solo se mantiene líquido si está comprimido.',3),
('g4','mc','gases','¿Cuántos m³ de aire se necesitan para quemar 1 m³ de Gas Grado 1 (Propano)?','["9 m³ de aire","17 m³ de aire","24 m³ de aire","30 m³ de aire"]',2,null,'Para la combustión de 1 m³ de Gas Grado 1 (Propano) se necesitan 24 m³ de aire. El Butano necesita 30 m³ de aire por m³ de gas.',4),
('g5','mc','gases','¿Cuál es la presión de utilización del Gas Grado 1?','["180 mmca","220 mmca","280 mmca","320 mmca"]',2,null,'El Gas Grado 1 (Propano) tiene una presión de utilización de 280 mmca. El Gas Grado 3 (Butano) tiene 320 mmca.',5),
('g6','mc','gases','¿Cuál es la densidad del Gas Grado 3 (Butano)?','["0,65","1,00","1,52","1,91"]',3,null,'El Gas Grado 3 (Butano, C4H10) tiene una densidad de 1,91. El Gas Grado 1 (Propano) tiene densidad 1,52. El Gas Natural tiene densidad 0,60-0,65.',6),
('g7','mc','gases','¿Cuáles son los productos NO tóxicos de la combustión completa?','["CO y nitrógeno","CO₂, vapor de agua y nitrógeno","Dióxido de azufre y CO₂","Metano y CO"]',1,null,'Los productos de combustión completa son CO₂, vapor de agua y nitrógeno, que NO son tóxicos. El CO (monóxido de carbono) SÍ es tóxico y aparece en combustión incompleta.',7),
('g8','mc','gases','¿En qué envases se distribuye el Gas Grado 3 (Butano)?','["Cilindros de 45 kg","Garrafas de 10 kg y 15 kg","Camiones cisterna","Garrafones de 0,5 m³"]',1,null,'El Gas Grado 3 (Butano) se distribuye en garrafas de 10 kg y 15 kg. El Propano (Grado 1) va en cilindros de 45 kg. El gas a granel usa tanques de 1 a 7,3 m³.',8),
('g9','mc','gases','¿Cuál es el poder calorífico del Gas Natural del yacimiento de Plaza Huincul?','["9.300 Kcal/m³","9.600 Kcal/m³","13.000 Kcal/m³","22.380 Kcal/m³"]',1,null,'Plaza Huincul: 9.600 Kcal/m³. Comodoro Rivadavia y Campo Durán: 9.300 Kcal/m³. Mendoza: 13.000 Kcal/m³ (el más alto).',9),
('g10','mc','gases','¿Qué es el Gas Natural Sintético (GNS)?','["Gas natural de pozos profundos","Mezcla de propano/butano con aire para igualar el índice Wobbe del GN","Gas metano de residuos orgánicos","Butano licuado a alta presión"]',1,null,'El GNS se obtiene mezclando GLP (propano/butano) con aire en proporciones que igualan el índice Wobbe del Gas Natural, inyectándose en el sistema de distribución.',10),
('g11','mc','gases','¿Qué representa el contenido de un cilindro de 45 kg de Gas Grado 1?','["12 m³ y 268.560 Kcal","24 m³ y 537.120 Kcal","45 m³ y 418.500 Kcal","50 m³ y 1.000.000 Kcal"]',1,null,'Un cilindro de 45 kg de Propano = 24 m³ de gas y 537.120 Kcal (24 × 22.380 Kcal/m³).',11),
('g12','mc','gases','¿Qué es el Biogás?','["Gas natural refinado","Gas generado por biodegradación de materia orgánica sin oxígeno (ambiente anaeróbico)","Propano industrial","Mezcla de GN y aire"]',1,null,'El biogás se genera por biodegradación de materia orgánica en ausencia de oxígeno (anaeróbico). Se obtiene de desperdicios orgánicos.',12),
-- NOCIONES (n1-n11)
('n1','mc','nociones','¿Qué establece el SIMELA?','["Normas de seguridad para gas","El sistema métrico legal argentino, de uso obligatorio y exclusivo","Sistema de medición de presiones","Normas de instalación de medidores"]',1,null,'El SIMELA (Sistema Métrico Legal Argentino) es el sistema de unidades vigente en Argentina, de uso obligatorio y exclusivo. Ley 19.511 de 1972.',13),
('n2','mc','nociones','¿Cuál es la definición de Caloría (cal)?','["Calor para elevar 1°C a 1 litro de agua","Calor para elevar 1°C a 1 gramo de agua (de 14,5 a 15,5°C)","Calor para elevar 10°C a 1 kg de agua","Calor producido por 1 m³ de gas en combustión"]',1,null,'La caloría es la cantidad de calor necesaria para elevar en 1°C (de 14,5 a 15,5°C) la temperatura de 1 gramo de agua. La kcal = 1.000 cal.',14),
('n3','mc','nociones','¿A qué temperatura Kelvin corresponde la ebullición del agua?','["0 K","100 K","273 K","373 K"]',3,null,'El agua hierve a 100°C = 373 K. Hielo funde a 0°C = 273 K. Cero absoluto: 0 K = -273°C.',15),
('n4','mc','nociones','¿Cómo se calcula el Consumo en m³/h de un artefacto?','["Potencia × Poder Calorífico","Potencia ÷ Poder Calorífico","Caudal × Presión","Temperatura ÷ Potencia"]',1,null,'Consumo (m³/h) = Potencia (Kcal/h) ÷ Poder Calorífico (Kcal/m³). Ej: 3.000 ÷ 9.300 = 0,32 m³/h.',16),
('n5','mc','nociones','¿Cuál es el calor específico del agua?','["0,5 kcal/kg·°C","1 kcal/kg·°C","4,18 kcal/kg·°C","9,3 kcal/kg·°C"]',1,null,'El calor específico del agua es 1 kcal/kg·°C. Se necesita 1 kcal para elevar 1 kg de agua en 1°C.',17),
('n6','mc','nociones','¿Qué es la presión?','["Velocidad de un fluido en tubería","Volumen de fluido por unidad de tiempo","Fuerza ejercida por unidad de superficie","Cantidad de calor de un combustible"]',2,null,'La presión es la fuerza ejercida por unidad de superficie (kg/cm²). Otras unidades: atmósfera, mmca, bar.',18),
('n7','mc','nociones','¿Cuáles son las tres formas de transmisión del calor?','["Ebullición, fusión y vaporización","Conducción, convección y radiación","Presión, temperatura y caudal","Combustión, oxidación y reducción"]',1,null,'Conducción (contacto), convección (movimiento de fluidos) y radiación (ondas electromagnéticas a 300.000 km/s).',19),
('n8','mc','nociones','¿Por qué los calefactores se colocan en la parte inferior de los ambientes?','["Para facilitar el mantenimiento","Por norma reglamentaria","Para aprovechar la convección: el aire caliente sube y el frío baja","Porque el gas es más pesado que el aire"]',2,null,'Por convección: el calefactor calienta el aire cercano que se vuelve menos denso y sube. El frío baja. Se ubican entre 10 y 20 cm del piso.',20),
('n9','mc','nociones','¿Qué es el Poder Calorífico de un combustible?','["Velocidad de combustión del gas","Cantidad de calor entregado por unidad de combustible durante la combustión","Temperatura a la que se enciende el gas","Presión mínima para que ocurra la combustión"]',1,null,'El poder calorífico es la cantidad de calor entregado por una unidad de combustible durante la combustión. Se mide en Kcal/m³ para gases.',21),
('n10','mc','nociones','¿Qué es el Caudal?','["La presión del gas en la tubería","El diámetro necesario para la tubería","El volumen de fluido que circula por una tubería en la unidad de tiempo","La potencia térmica de un artefacto"]',2,null,'El Caudal es el volumen de fluido que circula dentro de una tubería en la unidad de tiempo (m³/h). Fundamental para dimensionar cañerías.',22),
('n11','mc','nociones','La conversión de Celsius a Kelvin es:','["K = °C + 100","K = °C − 273","K = °C + 273","K = (°C × 9/5) + 32"]',2,null,'K = °C + 273. Cero absoluto (0 K) = -273°C. La última fórmula es Celsius a Fahrenheit.',23),
-- REGULADORES (r1-r9)
('r1','mc','reguladores','¿Cuál es la presión de salida normal de un regulador domiciliario?','["0,5 bar","0,019 bar (≈ 190 mmca)","4 bar","1 kg/cm²"]',1,null,'La presión de salida del regulador es 0,019 bar (~190 mmca). La presión de entrada puede ser de 0,5 a 4 bar.',24),
('r2','mc','reguladores','¿Dónde deben ubicarse los reguladores según la norma?','["Dentro del medidor","En un nicho sobre la línea municipal","En el interior del inmueble","En el sótano o garage"]',1,null,'Los reguladores deben estar en un nicho sobre la línea municipal, con una llave de paso tipo candado que los precede.',25),
('r3','mc','reguladores','¿Cuáles son las capacidades nominales de los reguladores?','["1, 2, 5, 10, 20 m³/h","6, 10, 25, 40, 65, 100 m³/h","5, 15, 30, 60, 90 m³/h","10, 20, 50, 100, 200 m³/h"]',1,null,'Capacidades nominales: 6, 10, 25, 40, 65 y 100 m³/h.',26),
('r4','mc','reguladores','¿Qué norma regula actualmente los reguladores de presión?','["NAG 135","NAG 235-1995","NAG 235-2019","NAG 500"]',2,null,'La NAG 235-2019 reemplaza a la NAG 135 y NAG 235-1995. Establece requisitos mínimos de seguridad, fabricación y funcionamiento para reguladores nuevos.',27),
('r5','mc','reguladores','¿Cuándo interrumpe el paso de gas un regulador?','["Solo por exceso de caudal","Solo por caída de presión de entrada","Por caída anormal de Pe o Ps, exceso de caudal o rotura del diafragma","Solo cuando se rompe el diafragma"]',2,null,'El regulador interrumpe cuando: caída anormal de presión de entrada, de salida, exceso de caudal o rotura del diafragma.',28),
('r6','mc','reguladores','¿Cómo se ajusta la presión en un regulador?','["Apretando el tornillo (rosca derecha) sale más presión","Apretando el tornillo (rosca izquierda) sale más presión","Aflojando el tornillo sale más presión","La presión no es ajustable manualmente"]',1,null,'Los reguladores son positivos: apretando el tornillo (rosca izquierda) sale más presión.',29),
('r7','mc','reguladores','¿Para qué tipo de consumo se usan los medidores de diafragma?','["Grandes industrias con altos caudales","Solo para GLP","Bajas presiones, domiciliarios hasta 10 m³/h (fabricados hasta 40 m³/h)","Solo para Gas Grado 1"]',2,null,'Medidores de diafragma: bajas presiones, domiciliarios hasta 10 m³/h, fabricados hasta 40 m³/h.',30),
('r8','mc','reguladores','¿Cuál es la ventaja principal de los medidores rotativos?','["Son más baratos","Alta precisión (0,5%), bajo mantenimiento, altas presiones y grandes consumos","Solo para Gas Grado 3","Son más pequeños"]',1,null,'Medidores rotativos: precisión 0,5% estándar, bajo mantenimiento, altas presiones. Se usan para grandes consumos (MAC).',31),
('r9','mc','reguladores','¿Qué tipo de rosca se usa en conexiones de cañería de gas?','["Rosca métrica paralela","Rosca Whitworth Gas (BSP - British Standard Pipe)","Rosca americana UNC","Rosca trapezoidal"]',1,null,'Se usa la rosca Whitworth Gas (BSP), con perfil Whitworth. Puede ser paralela o cónica; la cónica tiene inclinación de 1 mm por cada 16 mm de longitud.',32),
-- HERRAMIENTAS (h1-h8)
('h1','mc','herramientas','¿Cuál es la diferencia entre la Llave Stillson y la Llave Inglesa?','["Son lo mismo","La Stillson es para tubos (gran par), la Inglesa es para tuercas/tornillos","La Inglesa es fija","La Stillson solo se usa para gas"]',1,null,'Llave Stillson: para tubos (gran par de apriete), patentada en 1869. Llave Inglesa: ajustable, para tuercas y tornillos.',33),
('h2','mc','herramientas','¿Cuál es el instrumento principal para detectar fugas de gas?','["Manómetro","Columna de agua","Detector de gases","Termómetro"]',2,null,'El Detector de gases detecta fugas. También se usa detergente neutro en uniones. El manómetro y la columna de agua miden presión para pruebas de estanqueidad.',34),
('h3','mc','herramientas','¿Para qué sirve la Terraja?','["Medir diámetro de caños","Cortar caños","Hacer roscas en caños y tornillos","Doblar caños"]',2,null,'La Terraja (tarraja de roscar) es una herramienta de corte para el roscado manual de pernos y tornillos.',35),
('h4','mc','herramientas','¿Qué es la Termofusora?','["Medidor de temperatura del gas","Herramienta eléctrica para unir caños de polietileno por fusión","Equipo para detectar fugas","Instrumento para medir presión"]',1,null,'La Termofusora es una herramienta eléctrica para unir caños de polietileno (Sigas, Fusiogas, Vantec) por fusión térmica.',36),
('h5','mc','herramientas','¿Con qué se sella la rosca en conexiones de gas?','["Cinta de PVC","Silicona","Grasa grafitada o sella-roscas (pasta aprobada)","Pegamento epoxi"]',2,null,'Las conexiones se sellan con pastas aprobadas (sella-roscas) o grasa grafitada. Se verifica que no queden filetes expuestos fuera del accesorio.',37),
('h6','mc','herramientas','¿Qué equipo de seguridad personal es obligatorio para el gasista?','["Solo guantes de cuero","Guantes, antiparras, protectores auditivos y faja lumbar","Solo casco y botas","Solo mascarilla de gases"]',1,null,'Equipo de seguridad: guantes, antiparras, protectores auditivos, faja lumbar, cinta de peligro y botiquín de primeros auxilios.',38),
('h7','mc','herramientas','¿Para qué se usa la Columna de Agua?','["Almacenar agua en obras","Medir presiones bajas (mmca) en instalaciones de gas","Lavar piezas metálicas","Nivelar superficies"]',1,null,'La Columna de Agua mide presiones bajas en mmca. Verifica la presión de entrega del regulador (~180 mmca) y la caída de presión en la instalación (máx 10 mmca).',39),
('h8','mc','herramientas','¿Qué diferencia a la Llave Francesa de la Inglesa?','["No tienen diferencias","La Francesa es en T con doble garganta (obsoleta), la Inglesa es más pequeña y liviana","La Francesa es para agua, la Inglesa para gas","La Francesa es más moderna"]',1,null,'La Llave Francesa es en forma de T con doble garganta, popular en el siglo XIX. Fue sustituida por la Llave Inglesa, más liviana y pequeña.',40),
-- CIVIL (c1-c8)
('c1','mc','civil','¿Qué es la Nomenclatura Catastral?','["Nombre de la distribuidora de gas","Identificador del Catastro para individualizar parcelas","Número de matrícula del gasista","Código de la instalación de gas"]',1,null,'La Nomenclatura Catastral identifica parcelas. Ej: 15-21-001-9999-0000 (Nº de lote, manzana, dirección).',41),
('c2','mc','civil','¿Cuál es la documentación para presentar en la distribuidora de gas?','["Solo el plano de instalación","Certificado de domicilio y VEP","DNI y título habilitante únicamente","Solo el VEP"]',1,null,'Se necesita: Certificado de domicilio (constata el domicilio) y VEP (Verificación de Subsistencia del Estado Parcelario).',42),
('c3','mc','civil','¿Qué regla SIEMPRE debe respetarse con las cañerías de gas enterradas?','["Pueden doblarse con herramienta correcta","Solo pueden curvarse con radio mínimo 1 metro","La cañería NO se puede curvar ni torsionar bajo ninguna circunstancia","Pueden curvarse hasta 45° sin problemas"]',2,null,'La cañería de gas no se puede curvar ni torsionar de ninguna manera. Las zanjas deben ser rectas; los cambios de dirección se hacen con codos (accesorios).',43),
('c4','mc','civil','¿Cómo deben almacenarse los caños con recubrimiento epoxi?','["Se pueden arrastrar sobre el suelo","En lugares cerrados, separados del piso con material blando, sin golpearlos","Bajo el sol para curar el recubrimiento","Sumergidos en agua"]',1,null,'Los caños epoxi no se arrastran ni ruedan sobre el suelo. Se almacenan en lugares cerrados, separados del piso con material blando, alineados y sin golpes.',44),
('c5','mc','civil','¿Qué es el Replanteo en construcción?','["Proceso de fabricación de caños","Ubicación de puntos en el terreno según los planos, previo a la construcción","Verificación de presión al terminar la obra","Diseño del plano de instalación"]',1,null,'El Replanteo ubica en el terreno todos los puntos necesarios según los planos, como paso previo a la construcción. Para zanjas de gas se usan hilos guías sobre caballetes.',45),
('c6','mc','civil','¿Qué es un Chaflán u Ochava?','["Un tipo de accesorio de cañería","Recurso urbanístico que une con línea oblicua los lados de manzanas en esquinas","El espacio entre dos parcelas","Una herramienta para marcar el terreno"]',1,null,'El chaflán u ochava une con una línea oblicua los lados de manzanas en esquinas, mejorando la circulación y visibilidad.',46),
('c7','mc','civil','¿Cuáles son los componentes del mortero?','["Cemento, arena, grava y cal","Conglomerantes inorgánicos (cemento/cal), arena y agua","Solo cemento y agua","Arena, cal y yeso"]',1,null,'Morteros: mezcla de conglomerantes inorgánicos, áridos (arena), agua y posibles aditivos. El cemento se obtiene de calcinar a 1.450°C piedra caliza, arcilla y mineral de hierro.',47),
('c8','mc','civil','¿Qué es la Línea Municipal?','["La tubería principal de gas en la calle","Línea que deslinda la parcela de la vía pública, límite del área edificable en el frente","El eje que separa dos predios","El límite de la zona de excavación"]',1,null,'La Línea Municipal deslinda la parcela de la vía pública actual o futura, definiendo el área edificable en el frente de la parcela.',48);

-- ================================================================
-- FLASHCARDS (27)
-- ================================================================
insert into public.preguntas_banco (id,tipo,tema,texto,opciones,correcta,respuesta,explicacion,orden) values
('fl1','flash','gases','Fórmula del Propano y características',null,null,'C₃H₈ (Gas Grado 1) · Líquido a -44°C · Presión utilización: 280 mmca · Poder calorífico: 22.380 Kcal/m³ · Densidad: 1,52 · Cilindros de 45 kg = 24 m³ gas',null,101),
('fl2','flash','gases','Fórmula del Butano y características',null,null,'C₄H₁₀ (Gas Grado 3) · Líquido a -17°C · Presión utilización: 320 mmca · Poder calorífico: 27.482 Kcal/m³ · Densidad: 1,91 · Garrafas de 10 y 15 kg',null,102),
('fl3','flash','gases','¿Qué es la Combustión?',null,null,'Combinación rápida de un combustible con oxígeno, con producción de calor y luz. Productos NO tóxicos: CO₂, vapor de agua y N₂. El CO (monóxido de carbono) SÍ es tóxico (combustión incompleta).',null,103),
('fl4','flash','gases','Poder calorífico del Gas Natural por yacimiento',null,null,'Comodoro Rivadavia: 9.300 Kcal/m³ · Campo Durán: 9.300 Kcal/m³ · Plaza Huincul: 9.600 Kcal/m³ · Mendoza: 13.000 Kcal/m³ · Referencia de cálculo: 9.300 Kcal/m³',null,104),
('fl5','flash','gases','¿Qué es el Gas Natural Sintético (GNS)?',null,null,'Mezcla de propano/butano con aire que iguala el índice Wobbe del Gas Natural. Proceso: vaporizador → mezclador → red de distribución. Puede incluir calómetro y compresor.',null,105),
('fl6','flash','gases','¿Qué es el Biogás?',null,null,'Gas combustible generado por biodegradación de materia orgánica en ambiente anaeróbico (sin oxígeno). Se obtiene de desperdicios orgánicos (residuos vegetales).',null,106),
('fl7','flash','nociones','Conversión de escalas de temperatura',null,null,'°C a K: K = °C + 273 · °C a °F: °F = (°C × 9/5) + 32 · Referencias: agua hierve = 100°C = 373 K = 212°F · Cero absoluto = -273°C = 0 K',null,107),
('fl8','flash','nociones','SIMELA y Ley que lo establece',null,null,'Sistema Métrico Legal Argentino · Uso obligatorio y exclusivo en Argentina · Establecido por Ley 19.511 de 1972 · Basado en el Sistema Internacional de Unidades (SI)',null,108),
('fl9','flash','nociones','Fórmula de Consumo de un artefacto',null,null,'Consumo (m³/h) = Potencia (Kcal/h) ÷ Poder Calorífico (Kcal/m³) · Ejemplo: Calefactor 3.000 Kcal/h con GN → 3.000 ÷ 9.300 = 0,32 m³/h',null,109),
('fl10','flash','nociones','Tres formas de transmisión del calor',null,null,'1. CONDUCCIÓN: contacto entre sólidos · 2. CONVECCIÓN: movimiento de fluidos (calefactor abajo, frío arriba) · 3. RADIACIÓN: ondas electromagnéticas en el vacío, a 300.000 km/s',null,110),
('fl11','flash','nociones','Calor específico y unidades',null,null,'Calor Específico del agua = 1 kcal/kg·°C · 1 cal = calor para elevar 1g de agua en 1°C · 1 kcal = 1.000 cal = calor para elevar 1kg de agua en 1°C',null,111),
('fl12','flash','nociones','Presión y sus unidades',null,null,'Presión = Fuerza / Superficie · Unidades: kg/cm², atmósfera, mmca (milímetros de columna de agua), bar, Pa · Presión de distribución: varía por pérdidas de carga en el recorrido',null,112),
('fl13','flash','reguladores','Presiones del regulador domiciliario',null,null,'Entrada (Pe): 0,5 a 4 bar · Salida (Ps): 0,019 bar (~190 mmca) · Caída máxima en instalación: 10 mmca · Entrega al artefacto mínima: 170 mmca',null,113),
('fl14','flash','reguladores','NAG 235-2019 — alcance y qué reemplaza',null,null,'Reemplaza NAG 135 y NAG 235-1995 · Requisitos mínimos: seguridad, fabricación, funcionamiento y ensayos · Aplica a reguladores nuevos para GN y GLP · Incluye conexiones flexibles de entrada',null,114),
('fl15','flash','reguladores','Capacidades nominales de reguladores',null,null,'6 · 10 · 25 · 40 · 65 · 100 m³/h · Ubicación: nicho sobre línea municipal · Conexiones: en L (escuadra 90°) o en línea recta · Rosca positiva (izquierda): apretar = más presión',null,115),
('fl16','flash','reguladores','Medidor de diafragma vs. rotativo',null,null,'Diafragma: bajas presiones, domiciliario hasta 10 m³/h (fab. hasta 40), tiene juntas dieléctricas · Rotativo: grandes consumos (MAC), precisión 0,5%, presiones altas, 2 lóbulos rotativos',null,116),
('fl17','flash','reguladores','Rosca Whitworth Gas (BSP)',null,null,'British Standard Pipe Thread · Perfil Whitworth · Paralela o cónica · Inclinación cónica: 1 mm cada 16 mm de longitud · Uso: según norma en conexiones de caños y accesorios de gas',null,117),
('fl18','flash','herramientas','Llaves ajustables del gasista',null,null,'Stillson (llave de perro): tubos grandes, gran par de apriete, tamaños en pulgadas (8-48), patentada 1869 · Inglesa: tuercas y tornillos, cabeza móvil · Sueca: fontanería, anillo ajustable · Francesa: forma T, obsoleta',null,118),
('fl19','flash','herramientas','Sellado de roscas y materiales de unión',null,null,'Sella-roscas (pasta aprobada) o Grasa grafitada · También: cinta teflón · Verificar: no dejar filetes expuestos fuera del accesorio · Herramienta: terraja o roscadora eléctrica',null,119),
('fl20','flash','herramientas','Instrumentos de medición del gasista',null,null,'Columna de agua (presiones en mmca) · Manómetro (presiones) · Detector de gases (fugas) · Nivel de burbuja y manguera (nivelación) · Cinta métrica',null,120),
('fl21','flash','herramientas','Equipo de seguridad EPP del gasista',null,null,'Guantes · Antiparras · Protectores auditivos · Faja lumbar · Cinta de peligro · Botiquín de primeros auxilios · Calzado de seguridad',null,121),
('fl22','flash','herramientas','Termofusora — uso y aplicación',null,null,'Herramienta ELÉCTRICA para unir caños de Polietileno (PE) por fusión térmica · Materiales: Sigas, Fusiogas, Vantec · También: cortacaño y escariador para preparar el caño antes de fusionar',null,122),
('fl23','flash','civil','Documentación para presentación en distribuidora',null,null,'Certificado de domicilio: constata la veracidad del domicilio · VEP: Verificación de Subsistencia del Estado Parcelario · Nomenclatura Catastral: identifica la parcela (ej: 15-21-001-9999-0000)',null,123),
('fl24','flash','civil','Regla fundamental de cañerías de gas',null,null,'¡NUNCA curvar ni torsionar la cañería! Bajo ninguna circunstancia. Las zanjas deben ser rectas. Los cambios de dirección = codos (accesorios). Caballetes + hilos guías para el replanteo.',null,124),
('fl25','flash','civil','Almacenamiento de caños Epoxi vs PE-Acero',null,null,'Epoxi: no arrastrar ni rodar · Lugares cerrados · Separados del piso con material blando · No golpear · Proteger puntas del agua · PE-Acero: condiciones similares, proteger de radiación UV',null,125),
('fl26','flash','civil','Términos urbanísticos clave',null,null,'Línea Municipal: límite parcela / vía pública · Eje medianero: separa dos predios · Chaflán/ochava: corte oblicuo en esquinas · Mojón: poste que marca límites de territorio · Replanteo: traspaso de plano al terreno',null,126),
('fl27','flash','civil','Materiales de construcción: Mortero y Cemento',null,null,'Mortero: conglomerante + arena + agua + aditivos · Cemento: calcinación a 1.450°C de piedra caliza + arcilla + mineral de hierro → clínker → se muele con yeso · Arena: agregado fino · Agua: hidrata el cemento',null,127);

-- ================================================================
-- VERDADERO / FALSO (20)
-- correcta: 1 = VERDADERO, 0 = FALSO
-- ================================================================
insert into public.preguntas_banco (id,tipo,tema,texto,opciones,correcta,respuesta,explicacion,orden) values
('vf1','vf','gases','El metano (CH₄) representa el 95-98% del Gas Natural.',null,1,null,'Correcto. El Gas Natural es casi totalmente metano.',201),
('vf2','vf','gases','El Gas Grado 3 (Butano) tiene densidad 1,52.',null,0,null,'Falso. Densidad del Butano es 1,91. La densidad 1,52 es del Propano (Grado 1).',202),
('vf3','vf','gases','El Propano pasa a estado líquido a -44°C.',null,1,null,'Correcto. El Propano (C₃H₈) se licúa a -44°C.',203),
('vf4','vf','gases','El CO₂ es el gas tóxico que produce la combustión incompleta.',null,0,null,'Falso. El gas tóxico de combustión incompleta es el CO (monóxido de carbono), no el CO₂.',204),
('vf5','vf','gases','Los cilindros de 45 kg de Propano contienen 24 m³ de gas.',null,1,null,'Correcto. 45 kg ÷ 1,875 kg/m³ = 24 m³ · 24 × 22.380 = 537.120 Kcal.',205),
('vf6','vf','gases','El Biogás se produce en presencia de oxígeno (ambiente aeróbico).',null,0,null,'Falso. El Biogás se produce en ambiente ANAERÓBICO (sin oxígeno).',206),
('vf7','vf','gases','El Gas Natural de Mendoza tiene el mayor poder calorífico: 13.000 Kcal/m³.',null,1,null,'Correcto. Mendoza: 13.000 Kcal/m³, el más alto. Referencia de cálculo: 9.300 Kcal/m³.',207),
('vf8','vf','nociones','El SIMELA fue establecido por la Ley 19.511 de 1972.',null,1,null,'Correcto. La Ley 19.511 establece el Sistema Métrico Legal Argentino de uso obligatorio.',208),
('vf9','vf','nociones','1 Caloría es el calor para elevar 1°C la temperatura de 1 kg de agua.',null,0,null,'Falso. 1 cal = calor para 1 GRAMO. Para 1 kg se necesita 1 KILOcaloría (1 kcal = 1.000 cal).',209),
('vf10','vf','nociones','K = °C + 273. El agua hierve a 373 K.',null,1,null,'Correcto. 100°C + 273 = 373 K.',210),
('vf11','vf','nociones','Consumo (m³/h) = Potencia (Kcal/h) × Poder Calorífico (Kcal/m³).',null,0,null,'Falso. Consumo = Potencia ÷ Poder Calorífico (se DIVIDE, no multiplica).',211),
('vf12','vf','nociones','Los calefactores se ubican abajo porque el aire caliente sube por convección.',null,1,null,'Correcto. Convección: el calor sube, el frío baja. Calefactores entre 10 y 20 cm del piso.',212),
('vf13','vf','reguladores','La presión de salida del regulador domiciliario es de ~190 mmca (0,019 bar).',null,1,null,'Correcto. Presión de salida: 0,019 bar ≈ 190 mmca. Entrada: 0,5 a 4 bar.',213),
('vf14','vf','reguladores','Apretando el tornillo del regulador (rosca derecha) aumenta la presión de salida.',null,0,null,'Falso. Los reguladores tienen rosca IZQUIERDA: apretando (sentido antihorario) aumenta la presión.',214),
('vf15','vf','reguladores','La NAG 235-2019 reemplaza a la NAG 135 y NAG 235-1995.',null,1,null,'Correcto. La NAG 235-2019 es la norma vigente para reguladores de presión.',215),
('vf16','vf','reguladores','Los medidores rotativos se usan en instalaciones domiciliarias comunes.',null,0,null,'Falso. Los medidores de DIAFRAGMA son para uso domiciliario. Los ROTATIVOS son para grandes consumos (MAC).',216),
('vf17','vf','herramientas','La Llave Stillson se usa para tubos y tiene gran par de apriete.',null,1,null,'Correcto. La Stillson (llave de perro) es para tubos. Patentada en 1869.',217),
('vf18','vf','herramientas','La Termofusora une caños de acero mediante calor eléctrico.',null,0,null,'Falso. La Termofusora une caños de POLIETILENO (PE), no de acero.',218),
('vf19','vf','civil','La cañería de gas enterrada puede curvarse con radio mínimo de 1 metro.',null,0,null,'Falso. La cañería de gas NO se puede curvar ni torsionar bajo NINGUNA circunstancia. Solo codos.',219),
('vf20','vf','civil','La Línea Municipal deslinda la parcela de la vía pública.',null,1,null,'Correcto. Límite entre la propiedad privada y la calle/vía pública.',220);

-- ================================================================
-- COMPLETAR EL ESPACIO (15)
-- ================================================================
insert into public.preguntas_banco (id,tipo,tema,texto,opciones,correcta,respuesta,explicacion,orden) values
('cp1','completar','gases','El Gas Grado 1 (Propano) tiene un poder calorífico de ___ Kcal/m³.','["9.300","13.000","22.380","27.482"]',2,null,'22.380 Kcal/m³ es el poder calorífico del Propano. El GN tiene ~9.300 Kcal/m³.',301),
('cp2','completar','gases','Para quemar 1 m³ de Propano se necesitan ___ m³ de aire.','["9","17","24","30"]',2,null,'24 m³ de aire por m³ de Propano. El Butano necesita 30 m³.',302),
('cp3','completar','gases','El Gas Grado 3 (Butano) pasa a estado líquido a ___.','["-17°C","-44°C","0°C","-100°C"]',0,null,'-17°C. El Propano se licúa a -44°C (temperatura más baja).',303),
('cp4','completar','gases','La densidad del Gas Natural es de ___.','["0,60-0,65","1,00","1,52","1,91"]',0,null,'0,60-0,65. Más liviano que el aire (densidad 1,00), por eso sube en caso de fuga.',304),
('cp5','completar','nociones','La fórmula de conversión de Celsius a Kelvin es K = °C + ___.','["100","200","273","373"]',2,null,'K = °C + 273. El cero absoluto es 0 K = -273°C.',305),
('cp6','completar','nociones','Consumo (m³/h) = Potencia (Kcal/h) ___ Poder Calorífico (Kcal/m³).','["×","÷","+","-"]',1,null,'Se divide: Consumo = Potencia ÷ PC. Ej: 3.000 ÷ 9.300 = 0,32 m³/h.',306),
('cp7','completar','nociones','La transmisión de calor por movimiento de fluidos se llama ___.','["Conducción","Convección","Radiación","Combustión"]',1,null,'Convección: movimiento de fluidos. El calor sube, el frío baja.',307),
('cp8','completar','nociones','El calor específico del agua es ___ kcal/kg·°C.','["0,5","1","4,18","9,3"]',1,null,'1 kcal/kg·°C. Es la referencia universal para cálculos de calor.',308),
('cp9','completar','reguladores','Los reguladores domiciliarios se ubican en un nicho sobre la ___.','["medianera","línea municipal","vereda","fachada"]',1,null,'Sobre la línea municipal, con llave de paso tipo candado que los precede.',309),
('cp10','completar','reguladores','Las capacidades nominales de reguladores son: 6, 10, 25, 40, ___, 100 m³/h.','["50","60","65","75"]',2,null,'La secuencia es 6, 10, 25, 40, 65, 100 m³/h.',310),
('cp11','completar','reguladores','La inclinación de la rosca cónica Whitworth es de 1 mm cada ___ mm.','["8","12","16","20"]',2,null,'1 mm de inclinación por cada 16 mm de longitud de rosca (BSP cónica).',311),
('cp12','completar','herramientas','La Columna de Agua mide presiones bajas en ___.','["bar","kg/cm²","mmca","Pascal"]',2,null,'mmca (milímetros de columna de agua). Verifica presión del regulador (~180 mmca).',312),
('cp13','completar','herramientas','Las conexiones de gas se sellan con ___ o grasa grafitada.','["silicona","PVC","sella-roscas","pegamento"]',2,null,'Sella-roscas (pasta aprobada) o grasa grafitada. Nunca silicona común.',313),
('cp14','completar','civil','El cemento se obtiene calcinando a ___ °C piedra caliza, arcilla y mineral de hierro.','["800","1.100","1.450","1.800"]',2,null,'1.450°C. El proceso produce clínker que luego se muele con yeso.',314),
('cp15','completar','civil','El VEP significa Verificación de ___ del Estado Parcelario.','["Validez","Vigencia","Subsistencia","Veracidad"]',2,null,'VEP: Verificación de Subsistencia del Estado Parcelario. Documento requerido en la distribuidora.',315);
