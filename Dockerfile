FROM --platform=linux/ppc64le fedora:latest
RUN dnf install -y kernel-devel hostname diffutils rpmbuild bc dwarves openssl perl python3 rsync
