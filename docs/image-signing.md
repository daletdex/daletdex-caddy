# Image signing (Cosign keyless)

Harbor images are signed in GitHub Actions with **Cosign keyless** (Fulcio + Rekor) using the workflow OIDC identity. No Cosign private key is stored in the repo.

Image: `registry.hosting1337.com/daletdex/daletdex-caddy`

## What CI does

1. Build and push `:tag` (git tag, e.g. `v1.0.0`) with the Harbor robot.
2. Resolve the immutable digest (`sha256:…`).
3. `cosign sign` **by digest** (never tag-only).
4. `cosign verify` in the same job (fails the release if verification fails).

## Manual verify from a VPS

```bash
IMAGE=registry.hosting1337.com/daletdex/daletdex-caddy
TAG=vX.Y.Z   # deployed tag (includes leading v when that is the git tag)

docker login registry.hosting1337.com -u "$HARBOR_USER" -p "$HARBOR_PASS"

DIGEST="$(crane digest "${IMAGE}:${TAG}")"
# alternative: skopeo inspect "docker://${IMAGE}:${TAG}" | jq -r .Digest

cosign verify \
  --certificate-identity-regexp \
    '^https://github.com/daletdex/daletdex-caddy/\.github/workflows/docker-harbor\.yml@refs/(tags/v.+|heads/.+)$' \
  --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
  "${IMAGE}@${DIGEST}"
```

## Notes

- Source of truth is `cosign verify` against the digest, not only the Harbor UI “Signed” column.
- Cosign v2 in CI (classic `sha256-….sig` tags) for Harbor compatibility.
- Required GitHub Actions permission: `id-token: write`. Harbor secrets: `HARBOR_HOST`, `HARBOR_PROJECT`, `HARBOR_USER`, `HARBOR_PASS`.
- Harbor robot needs **push** on the image repository (to upload the signature artifact).
