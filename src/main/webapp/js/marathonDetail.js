



    setTimeout(function(){
    usercode=usercode1;// 실제 사용자 코드 가져오기
    /*  username=username1;*/
    console.log('User Code:', usercode); // 디버깅용 로그 추가

    // 페이지 로드 시 조회수 증가 요청
    fetch('/marathon/incrementViewCount', {
    method: 'POST',
    headers: {
    'Content-Type': 'application/json'
},
    body: JSON.stringify({
    marathon_code: marathonId // 요청 본문에 데이터를 포함
})
})
    .then(response => response.json())

    .then(data => {
    console.log(data)
    if (!data.success) {
    console.error("조회수 증가 실패:", data.message);
}
})
    .catch(error => {
    console.error("조회수 증가 요청 중 오류 발생:", error);
});

    // 좋아요 버튼 클릭 이벤트 처리
    const likeButton = document.getElementById('likeButton'); // 좋아요 버튼
    const heartIcon = document.getElementById('heartIcon'); // 하트 아이콘
    const likeCount = document.getElementById('likeCount'); // 좋아요 카운트 표시
    let count = parseInt(likeCount.textContent); // 현재 좋아요 수 가져오기
    let liked = false; // 좋아요 상태 플래그


    likeButton.addEventListener('click', function () {
    console.log('좋아요 버튼 클릭됨', usercode, marathonId); // 추가 로그
    // 서버에 좋아요 추가 요청
    fetch('/marathon/addLike', {
    method: 'POST',
    headers: {
    'Content-Type': 'application/json'
},
    body: JSON.stringify({
    usercode: usercode1,
    marathon_code: marathonId
})
})
    .then(response => response.json())
    .then(data => {
    console.log('서버에서 받은 데이터', data);
    if (data && data.success) {
    liked = !liked; // 좋아요 상태 토글
    if (liked) {
    heartIcon.classList.remove('far');
    heartIcon.classList.add('fas');
    likeButton.classList.add('clicked');
    count++;
} else {
    heartIcon.classList.remove('fas');
    heartIcon.classList.add('far');
    likeButton.classList.remove('clicked');
    count--;
}
    likeCount.textContent = count; // 좋아요 카운트 업데이트
} else {
    alert(data.message || '좋아요 추가 실패');
}
})
    .catch(error => {
    console.error('좋아요 추가에 실패했습니다:', error);
});

    // 초기 상태 설정
    function setInitialLikeState() {
    fetch(`/marathon/checkLike?usercode=${usercode}&marathon_code=${marathonId}`)
    .then(response => response.json())
    .then(data => {
    if (data.liked) {
    liked = true; // 사용자가 이미 좋아요를 눌렀다면
    heartIcon.classList.remove('far');
    heartIcon.classList.add('fas');
    likeButton.classList.add('clicked');
    count++; // 초기 카운트 설정
    likeCount.textContent = count; // 초기 카운트 업데이트
}
})
    .catch(error => {
    console.error('좋아요 상태 확인에 실패했습니다:', error);
});
}

    // 페이지 로드 시 초기 상태 설정
    document.addEventListener('DOMContentLoaded', setInitialLikeState);


});

    // 마라톤 거리 옵션 선택
    const marathonItem = document.getElementById('marathonDItem'); // 마라톤 거리 선택 요소
    const marathonSize = document.getElementById('marathonDSize');
    const totalPriceDisplay = document.querySelector('.DP');
    const cartButton = document.querySelector('.MC'); // 장바구니 버튼

    // 함수: 두 가지 선택 옵션이 모두 선택되었는지 확인 후 총 금액 표시
    function updateTotalPrice() {
    const itemPrice = parseInt(marathonItem.value);
    const sizeSelected = marathonSize.value !== '0'; // 사이즈가 선택되었는지 확인

    if (itemPrice > 0 && sizeSelected) {
    totalPriceDisplay.textContent = itemPrice + "원";
} else {
    totalPriceDisplay.textContent = "0원"; // 하나라도 선택되지 않으면 0원 표시
}
}
    // 옵션 변경 시 총 금액 업데이트
    marathonItem.addEventListener('change', updateTotalPrice);
    marathonSize.addEventListener('change', updateTotalPrice);

    // 장바구니 버튼 클릭 시
    cartButton.addEventListener('click', function() {
    const itemPrice = parseInt(marathonItem.value); // 선택한 상품 가격
    // 선택한 마라톤의 ID
    const sizeSelected = marathonSize.value !== '0'; // 사이즈 선택 여부 확인

    // 필수 항목 모두 선택 확인
    if (itemPrice > 0 && sizeSelected && usercode) {
    // 장바구니에 담을 데이터를 서버로 전송

    const cartData = {
    price: itemPrice,
    marathon_code: marathonId,
    usercode: usercode1,
    quantity: 1
};

    fetch('/marathon/addToCart', {
    method: 'POST',
    headers: {
    'Content-Type': 'application/json'
},
    body: JSON.stringify(cartData)
})
    .then(response => response.json())
    .then(data => {
    if (data.success) {
    // 모달 띄우기
    const cartModal = new bootstrap.Modal(document.getElementById('cartModal'), {});
    cartModal.show(); // 장바구니에 성공적으로 담기면 모달 띄움
} else {
    alert(data.message); // 실패 메시지 출력
}
})
    .catch(error => {
    console.error('Error adding to cart:', error);
    alert('장바구니에 담기 실패!');
});
} else {
    // 상품, 사이즈, 사용자 코드 선택 여부 확인 후 메시지 출력
    if (!usercode) {
    alert('로그인 후 다시 시도해주세요.'); // 로그인 미비 메시지
} else {
    alert('상품과 사이즈를 모두 선택해주세요.'); // 필수 항목 미선택 메시지
}
}
});

    // 장바구니로 이동 버튼 클릭 시
    document.getElementById('goToCartBtn').addEventListener('click', function() {
    window.location.href = '/cart/cart'; // 장바구니 페이지로 이동
});

    // 계속 쇼핑하기 버튼 클릭 시
    document.querySelector('.btn-secondary').addEventListener('click', function() {
    const cartModal = bootstrap.Modal.getInstance(document.getElementById('cartModal')); // 모달 인스턴스 가져오기
    cartModal.hide(); // 모달 닫기
    // 마라톤 리스트 페이지로 이동
    window.location.href = '/marathon/marathonList'; // 또는 사용자가 원래 있던 페이지로 이동
});
    map()
},300);

/*

    function map() {
        var infowindow = new kakao.maps.InfoWindow({zIndex:1});

        var mapContainer = document.getElementById('map'), // 지도를 표시할 div
            mapOption = {
                center: new kakao.maps.LatLng(latitude, longitude), // 지도의 중심좌표
                level: 4 // 지도의 확대 레벨
            };

        // 지도를 생성합니다
        var map = new kakao.maps.Map(mapContainer, mapOption);
        var imageSrc = '/img/runmaker.png', // 마커이미지의 주소입니다
            imageSize = new kakao.maps.Size(64, 69), // 마커이미지의 크기입니다
            imageOption = {offset: new kakao.maps.Point(27, 69)}; // 마커이미지의 옵션입니다.
        var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);

        // 사용자 위치 마커를 생성
        var marker = new kakao.maps.Marker({
            position: new kakao.maps.LatLng(latitude, longitude),
            image: markerImage
        });
        marker.setMap(map);

        // Ajax 요청으로 병원 목록 가져오기
        $.ajax({
            url: "/marathon/hospitalList",
            type: "post",
            data: {
                latitude: latitude,
                longitude: longitude
            },
            success: function(r) {
                var hospitals = r.hvoList;  // 서버로부터 받은 병원 목록 리스트

                // 병원 목록을 지도에 표시
                hospitals.forEach(function(hospital) {
                    displayMarker(hospital);
                });
            }
        });

        // 병원 위치에 마커를 표시하는 함수
        function displayMarker(hospital) {
            // 마커를 생성하고 지도에 표시
            var marker = new kakao.maps.Marker({
                map: map,
                position: new kakao.maps.LatLng(hospital.latitude, hospital.longitude)
            });

            // 마커에 클릭 이벤트 추가하여 병원 이름 표시
            kakao.maps.event.addListener(marker, 'click', function() {
                infowindow.setContent('<div style="padding:5px;font-size:12px;">' + hospital.name + '</div>');
                infowindow.open(map, marker);
            });
        }
    }



*/


    function map() {
        var infowindow = new kakao.maps.InfoWindow({zIndex: 1});

        var mapContainer = document.getElementById('map'),
            mapOption = {
                center: new kakao.maps.LatLng(latitude, longitude),
                level: 4
            };

        var map = new kakao.maps.Map(mapContainer, mapOption);

        var imageSrc = '/img/runmaker.png',
            imageSize = new kakao.maps.Size(64, 69),
            imageOption = { offset: new kakao.maps.Point(27, 69) };
        var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);

        var userMarker = new kakao.maps.Marker({
            position: new kakao.maps.LatLng(latitude, longitude),
            image: markerImage
        });
        userMarker.setMap(map);

        // Ajax 요청으로 병원 목록 가져오기
        $.ajax({
            url: "/marathon/hospitalList",
            type: "post",
            data: {
                latitude: latitude,
                longitude: longitude
            },
            success: function(r) {
                var hospitals = r.hvoList;

                // 병원 목록을 지도에 표시
                hospitals.forEach(function(hospital) {
                    displayMarker(hospital);
                });
            }
        });

        // 병원 위치에 마커와 툴팁을 표시하는 함수
        function displayMarker(hospital) {
            var position = new kakao.maps.LatLng(hospital.latitude, hospital.longitude);

            // 툴팁 마커 생성
            var tooltipMarker = new TooltipMarker(position, hospital.name);
            tooltipMarker.setMap(map);

            // MarkerTracker를 사용하여 지도 밖에 있는 마커를 추적
            var markerTracker = new MarkerTracker(map, tooltipMarker);
            markerTracker.run();
        }
    }

    // TooltipMarker 함수
    function TooltipMarker(position, tooltipText) {
        this.position = position;
        var node = this.node = document.createElement('div');
        node.className = 'node';

        var tooltip = document.createElement('div');
        tooltip.className = 'tooltip';
        tooltip.appendChild(document.createTextNode(tooltipText));
        node.appendChild(tooltip);

        node.onmouseover = function() {
            tooltip.style.display = 'block';
        };
        node.onmouseout = function() {
            tooltip.style.display = 'none';
        };
    }

    TooltipMarker.prototype = new kakao.maps.AbstractOverlay;

    TooltipMarker.prototype.onAdd = function() {
        var panel = this.getPanels().overlayLayer;
        panel.appendChild(this.node);
    };

    TooltipMarker.prototype.onRemove = function() {
        this.node.parentNode.removeChild(this.node);
    };

    TooltipMarker.prototype.draw = function() {
        var projection = this.getProjection();
        var point = projection.pointFromCoords(this.position);

        var width = this.node.offsetWidth;
        var height = this.node.offsetHeight;

        this.node.style.left = (point.x - width / 2) + "px";
        this.node.style.top = (point.y - height / 2) + "px";
    };

    TooltipMarker.prototype.getPosition = function() {
        return this.position;
    };

    // MarkerTracker 함수
    function MarkerTracker(map, target) {
        var OUTCODE = {
            INSIDE: 0,
            TOP: 8,
            RIGHT: 2,
            BOTTOM: 4,
            LEFT: 1
        };
        var BOUNDS_BUFFER = 30;
        var CLIP_BUFFER = 40;

        var tracker = document.createElement('div');
        tracker.className = 'tracker';

        var icon = document.createElement('div');
        icon.className = 'icon';

        var balloon = document.createElement('div');
        balloon.className = 'balloon';

        tracker.appendChild(balloon);
        tracker.appendChild(icon);

        map.getNode().appendChild(tracker);

        tracker.onclick = function() {
            map.setCenter(target.getPosition());
            setVisible(false);
        };

        function tracking() {
            var proj = map.getProjection();
            var bounds = map.getBounds();
            var extBounds = extendBounds(bounds, proj);

            if (extBounds.contain(target.getPosition())) {
                setVisible(false);
            } else {
                var pos = proj.containerPointFromCoords(target.getPosition());
                var center = proj.containerPointFromCoords(map.getCenter());

                var sw = proj.containerPointFromCoords(bounds.getSouthWest());
                var ne = proj.containerPointFromCoords(bounds.getNorthEast());

                var top = ne.y + CLIP_BUFFER;
                var right = ne.x - CLIP_BUFFER;
                var bottom = sw.y - CLIP_BUFFER;
                var left = sw.x + CLIP_BUFFER;

                var clipPosition = getClipPosition(top, right, bottom, left, center, pos);

                tracker.style.top = clipPosition.y + 'px';
                tracker.style.left = clipPosition.x + 'px';

                var angle = getAngle(center, pos);
                balloon.style.cssText +=
                    '-ms-transform: rotate(' + angle + 'deg);' +
                    '-webkit-transform: rotate(' + angle + 'deg);' +
                    'transform: rotate(' + angle + 'deg);';

                setVisible(true);
            }
        }

        function extendBounds(bounds, proj) {
            var sw = proj.pointFromCoords(bounds.getSouthWest());
            var ne = proj.pointFromCoords(bounds.getNorthEast());

            sw.x -= BOUNDS_BUFFER;
            sw.y += BOUNDS_BUFFER;

            ne.x += BOUNDS_BUFFER;
            ne.y -= BOUNDS_BUFFER;

            return new kakao.maps.LatLngBounds(
                proj.coordsFromPoint(sw),
                proj.coordsFromPoint(ne)
            );
        }

        function getClipPosition(top, right, bottom, left, inner, outer) {
            function calcOutcode(x, y) {
                var outcode = OUTCODE.INSIDE;
                if (x < left) outcode |= OUTCODE.LEFT;
                else if (x > right) outcode |= OUTCODE.RIGHT;
                if (y < top) outcode |= OUTCODE.TOP;
                else if (y > bottom) outcode |= OUTCODE.BOTTOM;
                return outcode;
            }

            var ix = inner.x, iy = inner.y, ox = outer.x, oy = outer.y;
            var code = calcOutcode(ox, oy);

            while (true) {
                if (!code) break;
                if (code & OUTCODE.TOP) { ox += (ix - ox) / (iy - oy) * (top - oy); oy = top; }
                else if (code & OUTCODE.RIGHT) { oy += (iy - oy) / (ix - ox) * (right - ox); ox = right; }
                else if (code & OUTCODE.BOTTOM) { ox += (ix - ox) / (iy - oy) * (bottom - oy); oy = bottom; }
                else if (code & OUTCODE.LEFT) { oy += (iy - oy) / (ix - ox) * (left - ox); ox = left; }
                code = calcOutcode(ox, oy);
            }

            return { x: ox, y: oy };
        }

        function getAngle(center, target) {
            var dx = target.x - center.x;
            var dy = center.y - target.y;
            return ((-Math.atan2(dy, dx) * 180 / Math.PI + 360) % 360 | 0) + 90;
        }

        function setVisible(visible) {
            tracker.style.display = visible ? 'block' : 'none';
        }

        function hideTracker() {
            setVisible(false);
        }

        this.run = function() {
            kakao.maps.event.addListener(map, 'zoom_start', hideTracker);
            kakao.maps.event.addListener(map, 'zoom_changed', tracking);
            kakao.maps.event.addListener(map, 'center_changed', tracking);
            tracking();
        };

        this.stop = function() {
            kakao.maps.event.removeListener(map, 'zoom_start', hideTracker);
            kakao.maps.event.removeListener(map, 'zoom_changed', tracking);
            kakao.maps.event.removeListener(map, 'center_changed', tracking);
            setVisible(false);
        };
    }




    // 키워드로 장소를 검색합니다
    /*    var keywords = ['병원', '의원', '응급시설'];
        keywords.forEach(function(keyword) {
            ps.keywordSearch(keyword, placesSearchCB);
        });

    // 키워드 검색 완료 시 호출되는 콜백함수 입니다
        function placesSearchCB (data, status, pagination) {
            if (status === kakao.maps.services.Status.OK) {

                // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
                // LatLngBounds 객체에 좌표를 추가합니다
                var bounds = new kakao.maps.LatLngBounds();

                for (var i=0; i<data.length; i++) {
                    displayMarker(data[i]);
                    bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
                }
            /!*    map.setBounds(bounds);*!/

                // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다

            }
        }*/