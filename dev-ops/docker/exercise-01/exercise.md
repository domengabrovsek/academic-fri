

FROM scratch
COPY hello /
CMD ["/hello"]

curl https://raw.githubusercontent.com/docker-library/hello-world/master/amd64/hello-world/hello -o hello