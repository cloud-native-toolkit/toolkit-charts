# Stan's Robot Shop

Use this helm chart to customise your install of Stan's Robot Shop.

### Helm v2.x

```shell
$ helm install --name robot-shop --namespace robot-shop .
```

### Helm v3.x

```bash
$ kubectl create ns robot-shop
$ helm install robot-shop --namespace robot-shop .
```

## Images

By default the images are pulled from Docker Hub. Setting `image.repo` this can be changed, for example:

```shell
$ helm install --set image.repo=eu.gcr.io/acme ...
```

Will pull images from the European Google registry project `acme`.

By default the latest version of the images is pulled. A specific version can be used:

```shell
$ helm install --set image.version=0.1.2 ...
```

It is recommened to always use the latest version.

## Pod Security Policy

If you wish to enable [PSP](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)

```shell
$ helm install --set psp.enabled=true ...
```

## Payment Gateway

By default the `payment` service uses https://www.paypal.com as the pseudo payment provider. The code only does a HTTP GET against this url. You can use a different url.

```shell
$ helm install --set payment.gateway=https://foobar.com ...
```

## Website Monitoring / End-User Monitoring

Optionally Website Monitoring / End-User Monitoring can be enabled for the web pages. Take a look at the [documentation](https://docs.instana.io/website_monitoring/) to see how to get a key and an endpoint url.

```shell
$ helm install \
    --set eum.key=xxxxxxxxx \
    --set eum.url=https://eum-eu-west-1.instana.io \
    ...
```

## Deployment Parameters

| Key              | Default | Type   | Description |
| ---------------- | ------- | ------ | ----------- |
| eum.key          | null    | string | EUM Access Key |
| eum.url          | https://eum-eu-west-1.instana.io | url | EUM endpoint URL |
| image.pullPolicy | IfNotPresent | string | Kubernetes pull policy. One of Always,IfNotPresent, or Never. |
| image.repo       | robotshop | string | Base docker repository to pull the images from. |
| image.version    | latest | string | Docker tag to pull. |
| nodeport         | false | booelan | Whether to expose the services via node port. |
| openshift        | false | boolean | If OpenShift additional configuration is applied. |
| payment.gateway  | null | string | External URL end-point to simulate partial/3rd party traces. |
| psp.enabled      | false | boolean | Enable Pod Security Policy for clusters with a PSP Admission controller |
| redis.storageClassName | standard | string | Storage class to use with Redis's StatefulSet. The default for EKS is gp2. |
| ocCreateRoute    | false | boolean | If you are running on OpenShift and need a Route to the web service, set this to `true` |
