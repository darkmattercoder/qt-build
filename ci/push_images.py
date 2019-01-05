#!/usr/bin/env python3

''' pushes all images to dockerhub that should exist with the tags from a yaml config '''

import yaml
import docker
import fire
import os


def push_image(image):
    ''' push a present docker image from a tag list to docker hub '''
    tags = {}
    with open(os.path.dirname(os.path.realpath(__file__)) + "/tags.yml", "r") as tagfile:
        tags = yaml.load(tagfile)
    print(tags)
    currentTag = image.split(":", 1)[1]
    for mainTag, subTags in tags.items():
        if mainTag == currentTag:
            if subTags != None:
                for tag in subTags:
                    imageName = image.split(":", 1)[0]
                    newImage = imageName + ":" + tag
                    print("pushing image " + newImage)
                    docker.from_env().images.push(newImage)


if __name__ == '__main__':
    fire.Fire(push_image)
