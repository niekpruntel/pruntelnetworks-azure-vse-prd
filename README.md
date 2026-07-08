# pruntelnetworks-azure-vse-prd

Azure infrastructure-as-code repository for the `pruntelnetworks-vse-prd` subscription.

This repository uses Bicep for Azure infrastructure definitions. It owns the Pruntel Networks web workload resource group and does not define workload resources yet.

## Repository layout

```text
bicep/
  main.bicep
  modules/
parameters/
  prd.bicepparam
.github/
  workflows/
```

## Existing resource group boundaries

This repository creates and manages:

| Resource group | Purpose |
| --- | --- |
| `pnw-web` | PruntelNetworks web workload resources |

Shared resource groups already exist and are not created or managed by this repository:

| Resource group | Purpose |
| --- | --- |
| `prd-network` | Shared networking resources |
| `prd-monitoring` | Shared monitoring resources |

Shared networking and monitoring resources will only be referenced later if the web workload requires them.
