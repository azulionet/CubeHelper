import json
import os
import requests
import shutil
import certifi
from tqdm import tqdm

print("api call")

from_file_name = "filtered_card.json"
dest_file_name = "uploader_card.json"

# downloaded file strip
def StripFile(from_file_name, dest_file_name):

    print("for uploader - StripFile() called : " + from_file_name)

    with open(from_file_name, 'r', encoding='utf-8') as file:
        data = json.load(file)

    # 필터링할 항목
    desired_keys = ["id", "name", "set", "collector_number"]

    filtered_data = []

    for item in tqdm(data, desc="Filtering"):
        
        new_item = {key: item[key] for key in desired_keys if key in item}
        filtered_data.append(new_item)


    # 결과를 새 JSON 파일에 저장
    with open(dest_file_name, 'w') as file:
        json.dump(filtered_data, file)

    print(" $$$ ------------------------------------------------------")
    print(" $$$ ------------------------------------------------------")

    print("every data count : " + str(len(data)))
    print("for uploader - StripFile() finished")

# program 시작

StripFile(from_file_name, dest_file_name)

print("for uploader - python program finished")

