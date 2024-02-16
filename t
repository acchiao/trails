[1mdiff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml[m
[1mindex 6d66883..0849f98 100644[m
[1m--- a/.github/workflows/ci.yml[m
[1m+++ b/.github/workflows/ci.yml[m
[36m@@ -72,7 +72,7 @@[m [mjobs:[m
       - uses: docker/setup-qemu-action@v1[m
       - uses: docker/setup-buildx-action@v2[m
       - uses: docker/login-action@v1[m
[31m-        if: ${{ github.ref == 'refs/heads/main' }}[m
[32m+[m[32m        # if: ${{ github.ref == 'refs/heads/main' }}[m
         # if: ${{ github.event_name != 'pull_request' }}[m
         with:[m
           registry: registry.hub.docker.com[m
[36m@@ -80,7 +80,7 @@[m [mjobs:[m
           password: ${{ secrets.REGISTRY_TOKEN }}[m
       - uses: docker/metadata-action@v4[m
         id: meta[m
[31m-        if: ${{ github.ref == 'refs/heads/main' }}[m
[32m+[m[32m        # if: ${{ github.ref == 'refs/heads/main' }}[m
         # if: ${{ github.event_name != 'pull_request' }}[m
         with:[m
           images: |[m
[36m@@ -206,7 +206,7 @@[m [mjobs:[m
     name: Release[m
     runs-on: ubuntu-20.04[m
     needs: [build, codeql, brakeman, rubocop, manifests, lint][m
[31m-    if: ${{ github.ref == 'refs/heads/main' }}[m
[32m+[m[32m    # if: ${{ github.ref == 'refs/heads/main' }}[m
     # if: ${{ github.event_name != 'pull_request' }}[m
     steps:[m
       - uses: googlecloudplatform/release-please-action@v3[m
