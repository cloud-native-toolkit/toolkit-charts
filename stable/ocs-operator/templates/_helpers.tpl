{{/*
Create the vSphere infra machineset providerSpec
*/}}
{{- define "refarch-ocp4-gitops.vsphere.machineset.infraProviderSpec" -}}
          apiVersion: vsphereprovider.openshift.io/v1beta1
          credentialsSecret:
            name: vsphere-cloud-credentials
          diskGiB: {{ .Values.vsphere.infraNodes.diskGiB }}
          kind: VSphereMachineProviderSpec
          memoryMiB: {{ .Values.vsphere.infraNodes.memoryMib }}
          metadata:
            creationTimestamp: null
          network:
            devices:
            - networkName: {{ .Values.vsphere.networkName }}
          numCPUs: {{ .Values.vsphere.infraNodes.numCPUs }}
          numCoresPerSocket: {{ .Values.vsphere.infraNodes.numCoresPerSocket }}
          snapshot: ""
          template: {{ .Values.infrastructureId }}-rhcos
          userDataSecret:
            name: worker-user-data
          workspace:
            datacenter: {{ .Values.vsphere.datacenter }}
            datastore: {{ .Values.vsphere.datastore }}
            folder: {{ .Values.vsphere.folder }}
            resourcePool: {{ .Values.vsphere.resourcePool }}
            server: {{ .Values.vsphere.server }}
{{- end }}

{{/*
Create the vSphere storage machineset providerSpec
*/}}
{{- define "refarch-ocp4-gitops.vsphere.machineset.storageProviderSpec" -}}
          apiVersion: vsphereprovider.openshift.io/v1beta1
          credentialsSecret:
            name: vsphere-cloud-credentials
          diskGiB: {{ .Values.vsphere.storageNodes.diskGiB }}
          kind: VSphereMachineProviderSpec
          memoryMiB: {{ .Values.vsphere.storageNodes.memoryMiB }}
          metadata:
            creationTimestamp: null
          network:
            devices:
            - networkName: {{ .Values.vsphere.networkName }}
          numCPUs: {{ .Values.vsphere.storageNodes.numCPUs }}
          numCoresPerSocket: {{ .Values.vsphere.storageNodes.numCoresPerSocket }}
          snapshot: ""
          template: {{ .Values.infrastructureId }}-rhcos
          userDataSecret:
            name: worker-user-data
          workspace:
            datacenter: {{ .Values.vsphere.datacenter }}
            datastore: {{ .Values.vsphere.datastore }}
            folder: {{ .Values.vsphere.folder }}
            resourcePool: {{ .Values.vsphere.resourcePool }}
            server: {{ .Values.vsphere.server }}
{{- end }}