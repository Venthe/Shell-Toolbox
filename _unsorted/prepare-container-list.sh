docker image ls --format "{{.Repository}}:{{.Tag}}" | uniq -u | sort
crictl images ls | awk '{print $1":" $2}' | uniq -u | sort

# More legit, requires JQ
sudo crictl images --output=json ls \
    | jq '
    .images|
    map(.repoTags[0])|
    reduce .[] as $item (""; .+$item+"\n")
    ' \
    --raw-output |\
    uniq -u \
    | sort