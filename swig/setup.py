
import os
from setuptools import setup
from setuptools.extension import Extension

this_dir = os.path.dirname(os.path.abspath(__file__))

setup(
    name='deep-capture',
    version='0.0.1',
    author='Zihao Zhang',
    author_email="zzh8829@gmail.com",
    description='Video Capture for Deep Learning',
    long_description='N/A',
    url='https://github.com/zzh8829/deep-capture',
    classifiers=[
        "Programming Language :: Python :: 3",
        "Topic :: Multimedia :: Graphics :: Capture :: Screen Capture"
    ],
    zip_safe=False,
    include_package_data=True,
    install_requires=[
        "numpy",
    ]
)