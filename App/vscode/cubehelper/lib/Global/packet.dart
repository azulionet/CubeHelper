class DBCubeInfo {
// uuid
// 큐브 오너
// 큐브 버전
// 큐브 이름
// 큐브 설명
// 큐브 설명 url
}

class DBCubeCardList {
// uuid
// 큐브 오너
// 카드 리스트
}

// 젠킨스를 통해 scryfall의 mtg 카드 풀 데이터 필터링한 내용을 올림
// 필터링 된 mtg카드 다운로드
// firebaseStorage - requestCardData()

// 큐브 업로드는 웹앱을 통해 이뤄짐
// 업로드된 큐브의 리스트를 받는 함수
// firebaseRealtimeDB - requestCubeList()

// 리얼 타임 DB에는 카드 아이디, 태그만 올라감
// 해당 큐브의 리스트를 받는 함수
// firebaseRealtimeDB - requestCardList()
