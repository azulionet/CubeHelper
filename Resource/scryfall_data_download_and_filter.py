import json
import os
import requests
import shutil
import certifi
from tqdm import tqdm

print("api call")

# scryflall file download
def GetScryfallUploadedFile():

    print("GetScryfallUploadedFile() called")

    url = "https://api.scryfall.com/bulk-data"
    targetJson = "default_cards.json"
    
    response = requests.get(url)
    fileName = ""

    # 응답이 성공적이면
    if response.status_code >= 200 and response.status_code < 300:

        print("call result 200")

        data = response.json()

        for item in data["data"]:
            if item["type"] == "default_cards":

                download_uri = item["download_uri"]

                print("parsed .json url : " + download_uri)

                download_response = requests.get(download_uri, stream=True, verify=certifi.where())

                if download_response.status_code >= 200 and download_response.status_code < 300:

                    if os.path.exists(targetJson):
                        os.remove(targetJson)

                    with open(targetJson, 'wb') as f:
                        print("file write start fileName : " + targetJson)
                        download_response.raw.decode_content = True
                        shutil.copyfileobj(download_response.raw, f)

                    fileName = targetJson

                break

    print("GetScryfallUploadedFile() end")
    return fileName

# json filtering condition
def json_item_condition(json_item, desired_keys, set_layout, remove_list, oversized_data, image_sub_keys):

    if "oversized" in json_item:
        if json_item["oversized"] == True:
            oversized_data.append(json_item)
            return None
    
    if "layout" in json_item:

        nowLayout = json_item["layout"]        
        set_layout.add(nowLayout)

        if( nowLayout in remove_list):
            return None

        new_item = {key: json_item[key] for key in desired_keys if key in json_item}

        # image_uris 항목이 있는 경우 해당 값들도 추출
        if 'image_uris' in json_item:
            for subkey in json_item['image_uris']:

                for argSubKey in image_sub_keys:
                    if subkey == argSubKey:
                        new_item[f'image_uris_{subkey}'] = json_item['image_uris'][subkey]

        return new_item

def StripFile(fileName):

    # "set_id" : c1d109bc-ffd8-428f-8d7d-3f8d7e648046
    # "set_name" : Time Spiral
    # "set" : tsp
    # image_uir = [image_uris], small, normal, large, png, art_crop, border_crop
    # sub_uri = ["related_uris"], gatherer, edhrec
    # array_to_string_keys = ["colors", "color_identity"]

    print("StripFile() called : " + fileName)

    with open(fileName, 'r', encoding='utf-8') as file:
        data = json.load(file)

    result_file_name = "filtered_card.json"
    set_layout = set()

    # 현존하는 레이아웃 종류
    exist_layout = [
        "class",                            # wizard class 이런애들
        "normal",                           # 일반 카드
        "host",                             # un시리즈, 합체몹    
        "emblem",                           # emblem
        "token",                            # token    
        "adventure",                        # adventure 카드들
        "split",                            # 스플릿
        "planar",                           # 차원 카드
        "modal_dfc",                        # 뒷면으로도 플레이 가능한 카드
        "meld",                             # 멜드 카드들
        "double_faced_token",               # 양면 토큰
        "art_series",                       # 일러만 있는 카드들
        "leveler",                          # 레벨업 능력 있는 애들
        "scheme",                           # scheme 
        "reversible_card",                  # 특수판, 동일 카드 양면 프린트
        "vanguard",                         # vanguard 
        "transform",                        # 뒤집 힘
        "saga",                             # saga
        "augment",                          # un사리즈 합체 소스 카드 ( host에 붙음 )
        "flip",                             # 구카미 위아래방향 뒤집는 카드
    ]

    # 새로운 레이아웃 추가시 알람을 위함
    extra_layout = set()
    remove_list = [
        "emblem",
        "token",
        "double_faced_token",
        "art_series",

        # "planar", "scheme", "vanguard" 일단 넣기로
    ]

    # 필터링할 항목
    desired_keys = [
                    "id",
                    "name",
                    "set", 
                    "scryfall_uri",
                    "mana_cost",
                    "rarity",               # uncommon
                    "type_line",            # Creature — Sliver
                    "collector_number"
                    ]

    image_sub_keys = ["image_uris_small", "image_uris_normal"]

    filtered_data = []
    oversized_data = []

    for item in tqdm(data, desc="Filtering"):        
        objResult = json_item_condition(item, desired_keys, set_layout, remove_list, oversized_data, image_sub_keys)

        if objResult != None:
            filtered_data.append(objResult)


    # 결과를 새 JSON 파일에 저장
    with open(result_file_name, 'w') as file:
        json.dump(filtered_data, file)

    print(" $$$ ------------------------------------------------------")
    print(" $$$ ------------------------------------------------------")
    print("every data count : " + str(len(data)))

    printS = ""
    for item in set_layout:
        printS += item
        printS += ", "

    print("set layout : " + printS)

    print("oversized card count" + str(len(oversized_data)))

    # 혹시 추가된 layout이 있는지 검사
    extra_layout = set_layout.difference(exist_layout)

    # 기존에 파싱이 되던 레이아웃이 아닌 리스트 추가시 알림 필요
    if len(extra_layout) > 0:
        print("not exist layout exists - " + str(len(extra_layout)))    
        for exLayout in extra_layout:
            print(" &&& [" + exLayout + "]")

    print("StripFile() finished")


# program 시작
fileName = GetScryfallUploadedFile()
root, extension = os.path.splitext(fileName)

if extension != ".json":
    print("ext not applyied")
    quit()

StripFile(fileName)

print("python program finished")
