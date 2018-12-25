### Build docker

    docker build -t web-video-capture .

    docker build -t gcr.io/hackaton2018-site-recorder/web-video-capture-image .

    docker tag web-video-capture gcr.io/hackaton2018-site-recorder/web-video-capture-image

	docker build -t web-video-capture -t gcr.io/hackaton2018-site-recorder/web-video-capture-image .
    docker push gcr.io/hackaton2018-site-recorder/web-video-capture-image


----
    #docker pull gcr.io/[PROJECT-ID]/quickstart-image:tag1
    #gcloud container images delete gcr.io/[PROJECT-ID]/quickstart-image:tag1 --force-delete-tags

### Run Container
    docker run -p 5900:5900 \
        -v /Users/bohdan/Projects/web-video-capture/videos:/home/apps/videos \
        -e VNC_SERVER_PASSWORD=password \
        -e CAPTURE_URL="https://www.youtube.com/watch?v=-oIJvTaUKyM" \
        --user apps \
        --privileged web-video-capture

    docker run \
    	--rm --name web-video-capture \
        -v $(pwd):/home/apps/videos \
        -e VNC_SERVER_PASSWORD=password \
        -e CAPTURE_URL="https://www.youtube.com/watch?v=-oIJvTaUKyM" \
        --user apps \
        --privileged web-video-capture

NOTICE. In order to stop capturing and not to compromise the mp4 output video run the following command.

## Stop recording
    docker exec <container_id> pkill ffmpeg


### Deploy to kubernets

	kubectl create -f ./redis-pod.yaml
	kubectl create -f ./redis-service.yaml

	./buildAndPush.sh
	kubectl create -f ./job.yaml

