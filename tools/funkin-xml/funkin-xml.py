import os
import sys
import xml.etree.ElementTree as ET
import re
import random

def parseInt(value, default=0):
    try:
        return int(value)
    except (ValueError, TypeError):
        return default

def parseBool(value, default=False):
    if value is None:
        return default
    return value.lower() in ['true', '1', 'yes']

def generateLuaFromXml(xmlPath):
    xmlName = os.path.split(xmlPath)[1]
    try:
        sheetXml = ET.parse(xmlPath).getroot()
    except ET.ParseError as e:
        print(f"Error parsing XML file {xmlPath}: {e}")
        return
    
    imgFile = sheetXml.attrib.get('imagePath', '')

    subTextures = {}
    for subTexture in sheetXml.findall('SubTexture'):
        name = subTexture.get('name', '')
        if not name:
            continue

        baseName = re.sub(r'\d+$', '', name)
        if baseName not in subTextures:
            subTextures[baseName] = []

        subTextures[baseName].append({
            'name': name,
            'x': parseInt(subTexture.get('x')),
            'y': parseInt(subTexture.get('y')),
            'width': parseInt(subTexture.get('width')),
            'height': parseInt(subTexture.get('height')),
            'offsetX': parseInt(subTexture.get('frameX')),
            'offsetY': parseInt(subTexture.get('frameY')),
            'offsetWidth': parseInt(subTexture.get('frameWidth')),
            'offsetHeight': parseInt(subTexture.get('frameHeight')),
            'rotated': parseBool(subTexture.get('rotated'))
        })

    lua = ('return graphics.newSprite(\n'
           f'\tgraphics.imagePath("{imgFile.replace(".png", "")}"),\n'
           '\t{\n'
           )
    
    animLists = {}
    count = 0
    for baseName, textures in subTextures.items():
        textures.sort(key=lambda t: int(re.search(r'(\d+)$', t['name']).group()))
        
        for texture in textures:
            count += 1
            lua += (f'\t\t{{x = {texture["x"]}, y = {texture["y"]}, width = {texture["width"]}, '
                    f'height = {texture["height"]}, offsetX = {texture["offsetX"]}, '
                    f'offsetY = {texture["offsetY"]}, offsetWidth = {texture["offsetWidth"]}, '
                    f'offsetHeight = {texture["offsetHeight"]}, rotated = {str(texture["rotated"]).lower()}}}, '
                    f'-- {count}: {texture["name"]}\n')

            if baseName in animLists:
                curAnim = animLists[baseName]
            else:
                curAnim = {}
                animLists[baseName] = curAnim
                curAnim["start"] = str(count)

            curAnim["stop"] = str(count)
            curAnim["speed"] = '24'
            curAnim["offsetX"] = '0'
            curAnim["offsetY"] = '0'
            curAnim["name"] = baseName

    lua += '\t},\n'
    lua += "\t{\n"

    for animName, animData in animLists.items():
        lua += (f'\t\t["{animData["name"]}"] = {{start = {animData["start"]}, '
                f'stop = {animData["stop"]}, speed = {animData["speed"]}, '
                f'offsetX = {animData["offsetX"]}, offsetY = {animData["offsetY"]}}},\n')

    lua += '\t},\n'
    lua += f'\t"{random.choice(list(animLists.values()))["name"]}",\n'
    lua += '\tfalse\n'
    lua += ")"

    luaFile = xmlName.replace('.xml', '') + '.lua'
    with open(luaFile, 'w') as f:
        f.write(lua)
    print(f"Converted {xmlName} to Lua script.")

def processPath(path):
    if os.path.isdir(path):
        for filename in os.listdir(path):
            if filename.endswith('.xml'):
                xmlPath = os.path.join(path, filename)
                generateLuaFromXml(xmlPath)
    elif os.path.isfile(path) and path.endswith('.xml'):
        generateLuaFromXml(path)
    else:
        print(f"Skipped {path}: not an XML file or directory.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <path1> [<path2> ... <pathN>]")
    else:
        for arg in sys.argv[1:]:
            processPath(arg)