# container-image-updater
This action prints "true" if image is required to update based on the base image update.

## Inputs

| Name                | Type     | Description                        |
|---------------------|----------|------------------------------------|
| `base-image`        | Required   | Base image of the image            |
| `image`             | Required   | The container image to be monitored, based on `base-image`   |
| `base-reg-username`, <br>`base-reg-password` | Optional   | Image registry credential to access base image.|
| `image-reg-username`, <br>`image-reg-password` | Optional   | Image registry credential to access image to be monitored.|


## Outputs

| Name                | Description                        |
|---------------------|------------------------------------|
| `needs-update`      | Returns `true` or `false`.         |

## Example usage

### Public images

```yaml
uses: mkumatag/container-image-updater-action@v1.0.5
with:
  base-image: 'alpine:3.14'
  image: 'alpine:3.13'
```

### Private images

```yaml
uses: mkumatag/container-image-updater-action@v1.0.5
with:
  base-image: 'alpine:3.14'
  image: 'alpine:3.13'
  base-reg-username: someuser
  base-reg-password: somepassword
  image-reg-username: someuser
  image-reg-password: somepassword
```