#!/bin/bash

while :
do
    if [[ -s /srv/yt/file_with_URL ]]; then
        if [[ ! -d '/srv/yt/downloads' ]]; then
            echo "Error: downloads/ does not exist"
            exit 1
        fi
        video_url=$(head -n1 /srv/yt/file_with_URL)
        title="$(youtube-dl --get-filename -o '%(title)s' "$video_url")"
        filename="$(youtube-dl --get-filename -o '%(title)s.%(ext)s' "$video_url")"
        description="$(youtube-dl --get-description $video_url)"

        dest_dir="/srv/yt/downloads/${title}"

        if [[ ! -d "${dest_dir}" ]]; then
            mkdir "${dest_dir}"
        fi

        youtube-dl -o "/srv/yt/downloads/${title}/${filename}" "$video_url"
        touch "/srv/yt/downloads/${title}/description"
        youtube-dl --get-description "$video_url" > "/srv/yt/downloads/${title}/description"

        if [[ ! -d '/var/log/yt/' ]]; then
                echo "Error : download.log does not exist"
                exit 1
        fi

        echo "$(date '+[%y/%m/%d %H:%M:%S]')" Video $video_url was downloaded. File path : /srv/yt/downloads/${title}/${filename} >> "/var/log/yt/download.log"
        echo "Video $video_url was downloaded."
        echo "File path /srv/yt/downloads/${title}/${filename}"
        sed -i '1d' /srv/yt/file_with_URL
    fi
        sleep 5 
        echo URL required
done
