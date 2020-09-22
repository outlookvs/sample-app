FROM alpine:3.11

# Install python3 and other deps
RUN apk add --no-cache python3
RUN pip3 install pip==20.2.2 --no-cache

# Install jinja2-cli
RUN pip3 install jinja2-cli[yaml,toml,xml]==0.7.0

ENTRYPOINT ["jinja2"]
