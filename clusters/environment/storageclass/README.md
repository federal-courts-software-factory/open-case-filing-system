When using Public Cloud, there will be extra adjustment needed so that TiKV can
use the right storage solution behind the scenes.

There are various documentation online, such as one for GKE
[[https://docs.pingcap.com/tidb-in-kubernetes/stable/deploy-on-gcp-gke#configure-storageclass]].
Refer to the one that makes sense for your use case, and include as a part of
the GitOps setup.
