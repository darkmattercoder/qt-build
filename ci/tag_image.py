#!/usr/bin/env python3

''' tags a given dockerfile tag with additional tags from yaml if present '''

import yaml
import docker
import fire
import os


def tag_image(image):
    ''' tag a present docker image with additional tags '''
    tags = {}
    with open(os.path.dirname(os.path.realpath(__file__)) + "/tags.yml", "r") as tagfile:
        tags = yaml.safe_load(tagfile)
    print(tags)
    currentTag = image.split(":", 1)[1]
    for mainTag, subTags in tags.items():
        if mainTag == currentTag:
            if subTags != None:
                for tag in subTags:
                    imageName = image.split(":", 1)[0]
                    newTag = imageName+":"+tag
                    print("retagging image " + image + " as " + newTag)
                    docker.from_env().images.get(image).tag(newTag)


if __name__ == '__main__':
    fire.Fire(tag_image)
