#!/bin/bash


# Docs for cleaning up Portworx installation at: https://cloud.ibm.com/docs/containers?topic=containers-portworx#portworx_cleanup
# Additional utilities for cleaning up Portworx installation available at https://github.com/IBM/ibmcloud-storage-utilities/blob/master/px-utils/px_cleanup/px-wipe.sh

echo "Wiping Portworx from cluster: $CLUSTER"

PATH=$BIN_DIR:$PATH

curl  -fSsL https://raw.githubusercontent.com/IBM/ibmcloud-storage-utilities/master/px-utils/px_cleanup/px-wipe.sh | bash -s -- --talismanimage icr.io/ext/portworx/talisman --talismantag 1.1.0 --wiperimage icr.io/ext/portworx/px-node-wiper --wipertag 2.5.0 --force

echo "removing the portworx helm from the cluster"
_rc=0
helm_release=$(helm ls -a --output json | jq -r '.[]|select(.name=="portworx") | .name')
if [ -z "$helm_release" ];
then
  echo "Unable to find helm release for portworx.  Ensure your helm client is at version 3 and has access to the cluster.";
else
  helm uninstall portworx || _rc=$?
  if [ $_rc -ne 0 ]; then
    echo "error removing the helm release"
    #exit 1;
  fi
fi

echo "removing all portworx storage classes"
kubectl get sc -A | grep portworx | awk '{ print $1 }' > sc.tmp
while read in; do
  kubectl delete sc "$in"
done < sc.tmp
rm -rf sc.tmp

echo "removing portworx artifacts"
kubectl delete serviceaccount -n kube-system portworx-hook --ignore-not-found=true
kubectl delete clusterrole -n kube-system portworx-hook --ignore-not-found=true
kubectl delete clusterrolebinding -n kube-system portworx-hook --ignore-not-found=true

kubectl delete Service portworx-service -n kube-system --ignore-not-found=true
kubectl delete Service portworx-api -n kube-system --ignore-not-found=true

kubectl delete serviceaccount -n kube-system portworx-hook --ignore-not-found=true 
kubectl delete clusterrole portworx-hook -n kube-system --ignore-not-found=true
kubectl delete clusterrolebinding portworx-hook -n kube-system --ignore-not-found=true

kubectl delete job -n kube-system talisman --ignore-not-found=true
kubectl delete serviceaccount -n kube-system talisman-account --ignore-not-found=true 
kubectl delete clusterrolebinding talisman-role-binding --ignore-not-found=true 
kubectl delete crd volumeplacementstrategies.portworx.io --ignore-not-found=true
kubectl delete configmap -n kube-system portworx-pvc-controller --ignore-not-found=true

kubectl delete secret -n default sh.helm.release.v1.portworx.v1 --ignore-not-found=true

# use the following command to verify all portworks resources are gone.  If you see a result here, it didn't work
# kubectl get all -A | grep portworx