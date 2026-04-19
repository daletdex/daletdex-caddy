# daletdex-caddy

Imagen mínima basada en **Caddy 2** para DaletDEX en Docker Swarm: TLS automático (Let’s Encrypt) y `reverse_proxy` al servicio interno **`daletdex-frontend:80`**.

## Variables de entorno

| Variable | Obligatoria | Descripción |
|----------|-------------|-------------|
| `DOMAIN` | Sí | Hostname público (ej. `app.daletdex.com`). Debe coincidir con DNS hacia el VPS. |

Los certificados y estado de ACME se guardan en el volumen montado en **`/data`** (en el stack: `${APP_DATA_ROOT}/caddy/data`). La configuración generada de Caddy usa **`/config`** (`…/caddy/config` en el host).

## Despliegue

Gestionado por **`daletdex-app`** (`stacks/stack-40-frontends.yml`): misma red `daletdex_pub`, puertos **80** y **443** en modo ingress. Antes: `bash scripts/stackctl.sh dirs` y `DOMAIN` + `CADDY_TAG` en `.env`.

## CI / Harbor

El workflow **docker-harbor** (tags `v*.*.*`) necesita en este repositorio los **mismos secretos** que el resto de imágenes DaletDEX (`HARBOR_HOST` o `HARBOR_REGISTRY`, `HARBOR_USERNAME` / `HARBOR_USER`, `HARBOR_PASSWORD`, `HARBOR_PROJECT`). Si el job falla con *Username and password required*, faltan esos secretos en **GitHub → Settings → Actions secrets** de **daletdex-caddy** (o secretos a nivel de organización enlazados al repo).
