# Arquitectura de Roles para Sistema Agentic

## 📋 Separación de Responsabilidades

Hemos implementado una **separación clara** entre dos tipos de roles:

### 1. **ROL** (Tabla Existente)
**Propósito**: Roles organizacionales del SG-SST
- Maneja la estructura organizacional de seguridad y salud
- Define responsabilidades específicas del SG-SST
- Ejemplos: CEO, Coordinador SST, Brigadista, Miembro COPASST

**Campos**:
```sql
- id_rol
- NombreRol
- Descripcion
- EsRolSST
```

### 2. **AGENTE_ROL** (Nueva Tabla)
**Propósito**: Permisos de acceso a agentes IA
- Controla qué agentes puede usar cada usuario
- Define niveles de acceso (1-4)
- Independiente de la estructura organizacional

**Campos**:
```sql
- id_agente_rol
- nombre_rol
- descripcion
- agentes_permitidos (JSON array)
- nivel_acceso (1=Básico, 2=Intermedio, 3=Avanzado, 4=Completo)
- activo
- FechaCreacion
- FechaActualizacion
```

---

## 🔗 Mapeo de Roles

### Tabla de Mapeo: EMPLEADO_AGENTE_ROL

Conecta empleados con sus roles de agentes:

```sql
- id_empleado_agente_rol
- id_empleado (FK -> EMPLEADO)
- id_agente_rol (FK -> AGENTE_ROL)
- FechaAsignacion
- FechaFinalizacion
- asignado_por
- motivo
```

---

## 👥 Roles de Agentes Disponibles

| Rol Agente | Nivel | Agentes Permitidos | Uso Típico |
|------------|-------|-------------------|------------|
| **admin** | 4 | Todos | CEO, Administradores del sistema |
| **sst_coordinator** | 4 | Todos | Coordinador SST, Responsable SG-SST |
| **copasst** | 3 | risk, document, assistant | Miembros del COPASST |
| **auditor** | 3 | document, assistant | Auditores internos/externos |
| **supervisor** | 2 | risk, assistant | Supervisores de área |
| **brigadista** | 2 | document, assistant | Brigadistas de emergencia |
| **employee** | 1 | assistant | Empleados estándar |
| **contractor** | 1 | assistant | Contratistas |

---

## 🎯 Agentes Disponibles

| Agente | Descripción | Capacidades |
|--------|-------------|-------------|
| **risk_agent** | Evaluación de riesgos | Identificación de peligros, matrices de riesgo, controles |
| **document_agent** | Procesamiento de documentos | Extracción PDF/DOCX, clasificación, compliance |
| **email_agent** | Comunicaciones | Generación de correos, notificaciones, alertas |
| **assistant_agent** | Asistente general | Consultas SG-SST, navegación, ayuda |

---

## 📊 Ejemplos de Asignación

### Mapeo Automático (basado en ROL organizacional)

```sql
-- CEO (id_rol=1) -> admin (nivel 4)
Empleado: Admin CEO
Rol Organizacional: CEO
Rol Agente: admin
Agentes: risk_agent, document_agent, email_agent, assistant_agent

-- Coordinador SST (id_rol=2) -> sst_coordinator (nivel 4)
Empleado: María Gómez
Rol Organizacional: Coordinador SST
Rol Agente: sst_coordinator
Agentes: risk_agent, document_agent, email_agent, assistant_agent

-- Brigadista (id_rol=3) -> brigadista (nivel 2)
Empleado: [Cualquier brigadista]
Rol Organizacional: Brigadista
Rol Agente: brigadista
Agentes: document_agent, assistant_agent

-- COPASST (id_rol=4) -> copasst (nivel 3)
Empleado: [Cualquier miembro COPASST]
Rol Organizacional: Miembro COPASST
Rol Agente: copasst
Agentes: risk_agent, document_agent, assistant_agent
```

### Asignación Manual

```sql
-- Supervisor sin rol organizacional específico
INSERT INTO EMPLEADO_AGENTE_ROL (id_empleado, id_agente_rol, motivo)
VALUES (
    105, 
    (SELECT id_agente_rol FROM AGENTE_ROL WHERE nombre_rol = 'supervisor'),
    'Supervisor de área con necesidad de evaluar riesgos'
)

-- Auditor externo temporal
INSERT INTO EMPLEADO_AGENTE_ROL (id_empleado, id_agente_rol, motivo, FechaFinalizacion)
VALUES (
    106,
    (SELECT id_agente_rol FROM AGENTE_ROL WHERE nombre_rol = 'auditor'),
    'Auditoría externa programada',
    '2025-12-31' -- Acceso temporal
)
```

---

## 🔒 Control de Acceso

### Flujo de Validación

1. **Usuario solicita usar un agente**
   ```python
   user_id = 102  # Juan López (Desarrollador)
   requested_agent = "risk_agent"
   ```

2. **Sistema consulta permisos**
   ```sql
   SELECT ar.agentes_permitidos
   FROM EMPLEADO_AGENTE_ROL ear
   JOIN AGENTE_ROL ar ON ear.id_agente_rol = ar.id_agente_rol
   WHERE ear.id_empleado = 102
     AND ear.FechaFinalizacion IS NULL
     AND ar.activo = 1
   ```

3. **Sistema valida acceso**
   ```python
   allowed_agents = ["assistant_agent"]  # Solo asistente
   
   if "risk_agent" not in allowed_agents:
       return "Error: No tienes permiso para usar risk_agent"
   ```

4. **Alternativa: Sugerir agente disponible**
   ```python
   return "Puedes usar: assistant_agent para consultas generales"
   ```

---

## 🛠️ Gestión de Roles

### Asignar Rol de Agente a Usuario

```sql
-- Asignar rol de supervisor a un empleado
INSERT INTO EMPLEADO_AGENTE_ROL (id_empleado, id_agente_rol, asignado_por, motivo)
VALUES (
    105,  -- id del empleado
    (SELECT id_agente_rol FROM AGENTE_ROL WHERE nombre_rol = 'supervisor'),
    100,  -- id del CEO que asigna
    'Promoción a supervisor de área'
)
```

### Revocar Acceso

```sql
-- Finalizar acceso de un empleado
UPDATE EMPLEADO_AGENTE_ROL
SET FechaFinalizacion = GETDATE()
WHERE id_empleado = 105
  AND id_agente_rol = (SELECT id_agente_rol FROM AGENTE_ROL WHERE nombre_rol = 'supervisor')
  AND FechaFinalizacion IS NULL
```

### Cambiar Rol

```sql
-- Finalizar rol actual
UPDATE EMPLEADO_AGENTE_ROL
SET FechaFinalizacion = GETDATE()
WHERE id_empleado = 105 AND FechaFinalizacion IS NULL

-- Asignar nuevo rol
INSERT INTO EMPLEADO_AGENTE_ROL (id_empleado, id_agente_rol, motivo)
VALUES (
    105,
    (SELECT id_agente_rol FROM AGENTE_ROL WHERE nombre_rol = 'sst_coordinator'),
    'Promoción a coordinador SST'
)
```

---

## 📈 Queries Útiles

### Ver Permisos de un Usuario

```sql
SELECT 
    e.Nombre + ' ' + e.Apellidos AS Usuario,
    e.Cargo,
    ar.nombre_rol AS RolAgente,
    ar.agentes_permitidos AS AgentesPermitidos,
    ar.nivel_acceso AS Nivel,
    ear.FechaAsignacion
FROM EMPLEADO e
JOIN EMPLEADO_AGENTE_ROL ear ON e.id_empleado = ear.id_empleado
JOIN AGENTE_ROL ar ON ear.id_agente_rol = ar.id_agente_rol
WHERE e.id_empleado = 102
  AND ear.FechaFinalizacion IS NULL
```

### Ver Todos los Usuarios por Nivel de Acceso

```sql
SELECT 
    ar.nivel_acceso,
    ar.nombre_rol,
    COUNT(DISTINCT ear.id_empleado) AS NumeroUsuarios
FROM AGENTE_ROL ar
LEFT JOIN EMPLEADO_AGENTE_ROL ear ON ar.id_agente_rol = ear.id_agente_rol
    AND ear.FechaFinalizacion IS NULL
GROUP BY ar.nivel_acceso, ar.nombre_rol
ORDER BY ar.nivel_acceso DESC
```

### Auditoría de Cambios de Roles

```sql
SELECT 
    e.Nombre + ' ' + e.Apellidos AS Usuario,
    ar.nombre_rol AS Rol,
    ear.FechaAsignacion,
    ear.FechaFinalizacion,
    ear.motivo,
    CASE 
        WHEN ear.FechaFinalizacion IS NULL THEN 'Activo'
        ELSE 'Finalizado'
    END AS Estado
FROM EMPLEADO_AGENTE_ROL ear
JOIN EMPLEADO e ON ear.id_empleado = e.id_empleado
JOIN AGENTE_ROL ar ON ear.id_agente_rol = ar.id_agente_rol
WHERE e.id_empleado = 102
ORDER BY ear.FechaAsignacion DESC
```

---

## 🔄 Integración con Backend

El `role_orchestrator.py` ahora consulta la base de datos:

```python
# Obtener permisos del usuario
permissions = await orchestrator.get_user_agent_permissions(user_id=102)

# Resultado:
{
    "user_id": 102,
    "role_name": "employee",
    "allowed_agents": ["assistant_agent"],
    "access_level": 1
}

# Validar acceso a agente
result = await orchestrator.orchestrate(
    user_id=102,
    task="Evaluar riesgos en bodega",
    preferred_agent="risk_agent"  # Será rechazado
)
```

---

## ✅ Ventajas de esta Arquitectura

1. **Separación Clara**: Roles organizacionales vs permisos de agentes
2. **Flexibilidad**: Un empleado puede tener múltiples roles de agentes
3. **Trazabilidad**: Historial completo de asignaciones y cambios
4. **Temporal**: Soporte para accesos temporales (auditores externos)
5. **Escalable**: Fácil agregar nuevos roles o agentes
6. **Auditable**: Registro de quién asignó qué y por qué
7. **Granular**: Control fino sobre qué agentes puede usar cada usuario

---

## 📝 Próximos Pasos

1. **Ejecutar script SQL**: `BD/setup_agentic_roles.sql`
2. **Verificar asignaciones**: Revisar que todos los empleados tengan roles
3. **Configurar API**: Integrar consultas de roles en endpoints
4. **Testing**: Probar acceso con diferentes usuarios
5. **Documentar**: Crear manual de usuario sobre roles y permisos
