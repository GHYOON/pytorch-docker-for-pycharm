# base image
FROM nvidia/cuda:10.2-base-ubuntu18.04
RUN apt-key del 7fa2af80
RUN apt-key del 3bf863cc
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
RUN apt-get update && apt-get install -y \
    curl ca-certificates sudo git bzip2 \
    libx11-6 && rm -rf /var/lib/apt/lists/*

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
 && chown -R user:user /app
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# All users can use /home/user as their home directory
ENV HOME=/home/user
RUN chmod 777 /home/user

# Install Miniconda and Python 3.6.7
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=/home/user/miniconda/bin:$PATH
RUN curl -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-py38_4.8.2-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && conda install -y python==3.6.7 \
 && conda clean -ya
 
# Install pytorch and other library
RUN conda install numpy scikit-learn scipy matplotlib
RUN conda install pandas
RUN conda install tensorflow=2.0.0
RUN conda install keras-gpu=2.3.1
RUN conda install jupyter notebook
RUN conda install opencv
RUN conda install -c conda-forge google-colab
#RUN conda install pytorch torchvision torchaudio cudatoolkit=10.2 -c pytorch && conda clean -ya

# setup jupyter notebbok
RUN jupyter notebook --generate-config
RUN cat /home/user/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.password='sha1:81b341c73ebf:d1778bb6a063c73cce95c7baa7d917f3b968946f'">>/home/user/.jupyter/jupyter_notebook_config.py
#kier

# Install Other Python env
#RUN conda create -n py37 python=3.7
#SHELL ["/bin/bash", "--login", "-c"]
#RUN /bin/bash -c "conda init bash"
#RUN echo 'conda activate py37' >> ~/.bashrc
#RUN conda install ipykernel
#RUN conda install tensorflow=2.1.0
#RUN pip install tensorflow==2.2.0
#RUN pip list |grep tensorflow
#RUN python -m ipykernel install --user --name py37 --display-name py37
#RUN echo 'conda deactivate' >> ~/.bashrc



# Set the default command to python3
CMD ["python3"]
