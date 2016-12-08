# mesos-packaging

Scripts to build [Apache Mesos](http://mesos.apache.com) against Alpine compatible 
[musl libc](http://www.musl-libc.org/) and protobuf bindings.

#### Usage

    docker build -t mesos-packaging .
    # Clone the entire source and checkout specific verison
    docker run --rm -ti -e MESOS_VERSION=1.1.x -v /tmp/build:/src mesos-packaging tiny
    # Build an existing source
    docker run --rm -ti -v $PWD/mesos:/src mesos-packaging tiny
    # Generate go protobuf bindings
    docker run --rm ti -v $PWD:/src mesos-packaging protoc-go


#### TODO: 

  * Generate all protobuf bindings
  * Build "full" version of Mesos with Java/Python bindings
  * Create distribution packages
  * Build against glibc
