#!/bin/bash
set -e

AURORA_MIRROR="https://archive.apache.org/dist/aurora"
AURORA_VERSION="0.9.0"

GRADLE_MIRROR="https://services.gradle.org/distributions"
GRADLE_VERSION="2.5"

MESOS_VERSION="0.22.2"

function usage {
    echo "Usage: $0 build_<component> [...]"
    echo
    echo "Component must be one of the following:"
    echo "scheduler, client, admin_client, thermos_executor, thermos_observer, all"
    exit 1
}

function install_lsb_core {
    if [[ -f /etc/redhat-release ]]; then
        echo "Installing prerequisite package 'redhat-lsb-core' ..."
        yum install -y redhat-lsb-core
    elif [[ -f /etc/debian_version ]]; then
        echo "Installing prerequisite package 'lsb-release' ..."
        apt-get update
        apt-get install -y lsb-release
    else
        echo "Error: only RHEL, CentOS, and Ubuntu are supported by this script."
        exit 1
    fi
}

function install_prerequisites {
    DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    echo "Downloading prerequisite packages for ${DISTRO}..."

    if [[ $DISTRO == "centos" ]] || [[ $DISTRO == "rhel" ]]; then
        yum update -y python
        yum install -y python-devel zip unzip java-1.8.0-openjdk-devel \
            gcc gcc-c++ kernel-headers
    fi

    if [[ $DISTRO == "ubuntu" ]]; then
        # Aurora requires Java 8 but it isn't available in Ubuntu 14.04 LTS
        # repositories. For now, we need to add the openjdk (restricted) PPA.
        # -- roger, 2016-01-10
        add-apt-repository -y ppa:openjdk-r/ppa
        apt-get update
        apt-get install -y python-dev zip unzip openjdk-8-jdk build-essential
        update-java-alternatives --set java-1.8.0-openjdk-amd64
    fi

    if [[ ! -d "/usr/local/gradle-${GRADLE_VERSION}" ]]; then
        install_gradle
    fi
}

function install_gradle {
    echo "Downloading Gradle ${GRADLE_VERSION} to ${PWD}..."
    curl -LO "${GRADLE_MIRROR}/gradle-${GRADLE_VERSION}-bin.zip"

    echo "Extracting Gradle to /usr/local/gradle-${GRADLE_VERSION}..."
    unzip "gradle-${GRADLE_VERSION}-bin.zip" -d /usr/local
    ln -fns "/usr/local/gradle-${GRADLE_VERSION}/bin/gradle" /usr/local/bin/gradle
    gradle --version
}

function download_aurora {
    echo "Downloading Aurora tarball to ${PWD}..."
    curl -LO "${AURORA_MIRROR}/${AURORA_VERSION}/apache-aurora-${AURORA_VERSION}.tar.gz"
    tar zxf "apache-aurora-${AURORA_VERSION}.tar.gz"
}

# NOTE: Mesosphere doesn’t make the Mesos native library for Python available
# for all operating systems and releases. The following instructions should
# work for at least RHEL/CentOS 7 and Ubuntu 14.04. For an up-to-date list of
# platforms that the native library is available for, check out
# http://open.mesosphere.com/downloads/mesos.
function download_mesos_native_libs {
    DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    RELEASE=$(lsb_release -rs)
    
    # For the Mesos native Python egg, Mesosphere's repositories understand
    # "centos" but not "rhel", and "7" but not "7.1.1503".
    if [[ $DISTRO == "centos" ]] || [[ $DISTRO == "rhel" ]]; then
        DISTRO="centos"
        RELEASE=$(lsb_release -rs | cut -d '.' -f1)
    fi

    MESOS_NATIVE_MIRROR="http://downloads.mesosphere.io/master/${DISTRO}/${RELEASE}"
    MESOS_NATIVE_DEST="mesos.native-${MESOS_VERSION}-py2.7-linux-x86_64.egg"

    echo "Modifying '${PWD}/3rdparty/python/requirements.txt' to use Mesos ${MESOS_VERSION}"
    sed -r -i "s/(mesos.*)==0.22.0/\1==${MESOS_VERSION}/" 3rdparty/python/requirements.txt

    [[ ! -d third_party ]] && mkdir third_party
    if [[ ! -f "third_party/${MESOS_NATIVE_DEST}" ]]; then
        echo "Downloading Mesos native library..."
        curl -L -o "third_party/${MESOS_NATIVE_DEST}" \
            "${MESOS_NATIVE_MIRROR}/mesos-${MESOS_VERSION}-py2.7-linux-x86_64.egg"
    fi
}

function build_scheduler {
    echo "Building the Aurora scheduler..."
    gradle distZip
}

function build_client {
    echo "Building the Aurora client..."
    ./pants binary src/main/python/apache/aurora/client/cli:aurora
    chmod +x dist/aurora.pex
}

function build_admin_client {
    echo "Building the Aurora admin client..."
    ./pants binary src/main/python/apache/aurora/admin:aurora_admin
    chmod +x dist/aurora_admin.pex
}

function build_thermos_executor {
    echo "Building the Thermos executor..."
    download_mesos_native_libs
    ./pants binary src/main/python/apache/aurora/executor/bin:thermos_executor
    ./pants binary src/main/python/apache/thermos/bin:thermos_runner
    build-support/embed_runner_in_executor.py
    chmod +x dist/thermos_executor.pex
}

function build_thermos_observer {
    echo "Building the Thermos observer..."
    download_mesos_native_libs
    ./pants binary src/main/python/apache/aurora/tools:thermos_observer
    chmod +x dist/thermos_observer.pex
}

function build_all {
    echo "Building all Aurora components..."
    build_scheduler
    build_client
    build_admin_client
    build_thermos_executor
    build_thermos_observer
}

function main {
    if [[ "$#" -eq 0 ]]; then
        echo "Must specify at least one component to build."
        usage
    fi

    MEM_TOTAL=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
    if [[ $MEM_TOTAL -lt 2035720 ]]; then
        echo "Error: your system needs at least 2 GB RAM to build Aurora."
        exit 1
    fi

    install_lsb_core
    install_prerequisites

    if [[ ! -f "${PWD}/apache-aurora-${AURORA_VERSION}.tar.gz" ]]; then
        download_aurora
    fi

    cd "apache-aurora-${AURORA_VERSION}"

    for component in "$@"; do
        build_$component
    done

    echo
    echo "Success! Aurora component(s) '$@' were built to '${PWD}/dist'"
}

main "$@"
