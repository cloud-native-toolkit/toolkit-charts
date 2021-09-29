# Assign Group Cronjob chart

This helm chart provisions a cronjob in a cluster that runs frequently (every 1 minutes by default) in search of new users that should be added to the provided group.

**Note:** This cronjob is a poor-man's admission controller or operator and may eventually be replaced to be a bit more efficient. If nothing else this logic shows that there is more than one way to implement logic in a cluster and that not everything needs to be an operator.

## Development

The shell scripts executed by the cronjob can be found in the scripts/ folder. Locating the scripts here makes it easier to test the logic. When the scripts have been tested and the logic is ready to be deployed, the scripts/_update-configmap.sh shell script can be used to update the script logic located in the config map template. The "header" of the config map template can be found in the support/ folder.

When the job starts, the contents of the config map are mounted as a volume and the shell scripts are available as executables in the pod.

Both the scripts/ and support/ folders have been added to .helmignore so the files don't get packaged with the helm chart.
