FROM nginx

COPY ./index.html /usr/share/nginx/html

RUN apt-get update && apt-get install \
	--no-install-recommends --no-install-suggests -y \
	wondershaper

CMD /bin/bash -c "wondershaper eth0 128 128 && nginx -g 'daemon off;'"
