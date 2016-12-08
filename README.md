# mesos-packaging

Scripts to build [Apache Mesos](http://mesos.apache.com) against Alpine compatible 
[musl libc](http://www.musl-libc.org/) and protobuf bindings.

#### Usage

    # Build against musl
    docker run --rm -v $PWD/build.sh:/entrypoint.sh -v $PWD/mesos:/src quay.io/vektorcloud/build compile musl
    # Build against glibc
    docker run --rm -v $PWD/build.sh:/entrypoint.sh -v $PWD/mesos:/src quay.io/vektorcloud/build:debian compile glibc
    # Generate go protobuf bindings
    docker run --rm -v $PWD/build.sh:/entrypoint.sh -v $PWD/mesos:/src quay.io/vektorcloud/build protoc-go


#### TODO: 

  * Generate all protobuf bindings
  * Build "full" version of Mesos with Java/Python bindings
  * Create distribution packages
  * Build against glibc
