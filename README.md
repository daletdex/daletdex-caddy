# daletdex-caddy

Imagen mínima basada en **Caddy 2** para DaletDEX en Docker Swarm: TLS automático (Let’s Encrypt) y `reverse_proxy` al servicio interno **`daletdex-frontend:80`**.

## Variables de entorno

| Variable | Obligatoria | Descripción |
|----------|-------------|-------------|
| `DOMAIN` | Sí | Hostname público (ej. `app.daletdex.com`). Debe coincidir con DNS hacia el VPS. |

Los certificados y estado de ACME se guardan en el volumen montado en **`/data`** (en el stack: `${APP_DATA_ROOT}/caddy/data`). La configuración generada de Caddy usa **`/config`** (`…/caddy/config` en el host).

## Despliegue

Gestionado por **`daletdex-app`** (`stacks/stack-40-frontends.yml`): misma red `daletdex_pub`, puertos **80** y **443** en modo ingress. Antes: `bash scripts/stackctl.sh dirs` y `DOMAIN` + `CADDY_TAG` en `.env`.
