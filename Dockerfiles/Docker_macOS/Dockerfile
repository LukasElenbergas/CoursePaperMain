FROM unityci/editor:ubuntu-2021.3.16f1-mac-mono-1

COPY build.sh /run

COPY id_ed25519 /root/.ssh/

RUN chmod 400 /root/.ssh/id_ed25519

RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN chmod 400 /root/.ssh

RUN eval $(ssh-agent -s) && \
    ssh-add -k /root/.ssh/id_ed25519 && \ 
    ssh-add -l && \
    cd /home && \ 
    git clone git@github.com:LukasElenbergas/CoursePaperTestProject.git

RUN cd /home && \
    git config --global user.email lukas.elenbergas@gmail.com && \
    git config --global user.name LukasElenbergas

ENTRYPOINT [ "/run/build.sh", "-m" ]