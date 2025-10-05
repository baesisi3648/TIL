import streamlit as st
import time
import random
from datetime import datetime, timedelta

# 페이지 설정
st.set_page_config(
    page_title="MarryRoute - 결혼까지 가장 짧은 경로",
    page_icon="💍",
    layout="wide",
    initial_sidebar_state="collapsed"
)

# CSS 스타일링
st.markdown("""
<style>
    .main {
        background: linear-gradient(135deg, #FEF7E0 0%, #FFFFFF 50%, #F7F3E9 100%);
    }
    
    .stApp {
        color: #92400E;
    }
    
    .hero-card {
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(217, 119, 6, 0.2);
        border-radius: 24px;
        padding: 2rem;
        box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        margin-bottom: 2rem;
    }
    
    .vendor-card {
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(217, 119, 6, 0.2);
        border-radius: 16px;
        padding: 1.5rem;
        margin-bottom: 1rem;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
    }
    
    .vendor-card:hover {
        transform: scale(1.02);
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
    }
    
    .stat-card {
        background: rgba(255, 255, 255, 0.5);
        backdrop-filter: blur(4px);
        border-radius: 16px;
        padding: 1.5rem;
        text-align: center;
        margin-bottom: 1rem;
    }
    
    .chat-container {
        background: rgba(255, 255, 255, 0.9);
        border-radius: 24px;
        padding: 1rem;
        height: 600px;
        display: flex;
        flex-direction: column;
    }
    
    .timeline-item {
        background: rgba(255, 255, 255, 0.9);
        border-radius: 16px;
        padding: 1.5rem;
        margin-bottom: 1rem;
        border-left: 4px solid #C8A96A;
    }
    
    .budget-progress {
        background: #E5E7EB;
        border-radius: 9999px;
        height: 12px;
        overflow: hidden;
        margin: 0.5rem 0;
    }
    
    .accent-btn {
        background: linear-gradient(135deg, #D4AF37 0%, #B8860B 100%);
        color: #92400E;
        border: none;
        border-radius: 12px;
        padding: 0.75rem 1.5rem;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    
    .accent-btn:hover {
        transform: scale(1.05);
    }
    
    .quick-action {
        background: rgba(255, 255, 255, 0.8);
        border: 1px solid rgba(217, 119, 6, 0.2);
        border-radius: 12px;
        padding: 0.5rem 1rem;
        margin: 0.25rem;
        font-size: 0.875rem;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    
    .quick-action:hover {
        background: rgba(217, 119, 6, 0.1);
        transform: scale(1.05);
    }
</style>
""", unsafe_allow_html=True)

# 초기 상태 설정
if 'current_view' not in st.session_state:
    st.session_state.current_view = 'chat'

if 'chat_messages' not in st.session_state:
    st.session_state.chat_messages = [
        {"role": "assistant", "content": "안녕하세요! 저는 AI 웨딩 플래너 마리예요 ✨ 어떤 도움이 필요하신가요?"}
    ]

# 데이터 정의
vendors = [
    {
        "id": "H1001",
        "name": "호텔 루미에르",
        "type": "웨딩홀",
        "price": "2,950만원",
        "priceNum": 29500000,
        "seat": "200석",
        "rating": 4.6,
        "reviews": 128,
        "perks": ["원본 제공", "주차 300대", "야간가든"],
        "image": "🏛️",
        "location": "강남구",
        "description": "유럽 클래식 스타일의 럭셔리 웨딩홀",
        "savings": "230만원 절약 가능"
    },
    {
        "id": "S2001",
        "name": "스튜디오 노바",
        "type": "스튜디오",
        "price": "350만원",
        "priceNum": 3500000,
        "seat": "촬영 3컨셉",
        "rating": 4.8,
        "reviews": 96,
        "perks": ["원본 제공", "야외 촬영", "드레스 대여"],
        "image": "📸",
        "location": "성수동",
        "description": "자연광이 아름다운 감성 스튜디오",
        "savings": "80만원 절약 가능"
    },
    {
        "id": "D3001",
        "name": "아틀리에 클레르",
        "type": "드레스",
        "price": "500만원",
        "priceNum": 5000000,
        "seat": "피팅 3회",
        "rating": 4.7,
        "reviews": 82,
        "perks": ["신상 라인", "수제 베일", "맞춤 수선"],
        "image": "👗",
        "location": "청담동",
        "description": "파리 컬렉션 브랜드 드레스 전문",
        "savings": "150만원 절약 가능"
    }
]

timeline_items = [
    {"id": 1, "title": "예식장 예약", "date": "2025-03-15", "status": "completed", "category": "venue"},
    {"id": 2, "title": "드레스 피팅", "date": "2025-04-20", "status": "upcoming", "category": "dress"},
    {"id": 3, "title": "스튜디오 촬영", "date": "2025-05-10", "status": "pending", "category": "photo"},
    {"id": 4, "title": "청첩장 발송", "date": "2025-06-01", "status": "pending", "category": "invitation"},
    {"id": 5, "title": "결혼식", "date": "2025-07-15", "status": "pending", "category": "wedding"}
]

budget_categories = [
    {"name": "웨딩홀", "budget": 3000, "spent": 2950, "color": "#C8A96A"},
    {"name": "스튜디오", "budget": 400, "spent": 350, "color": "#23C19C"},
    {"name": "드레스", "budget": 600, "spent": 500, "color": "#FF6B6B"},
    {"name": "메이크업", "budget": 200, "spent": 0, "color": "#845EC2"},
    {"name": "플라워", "budget": 150, "spent": 0, "color": "#FF9671"}
]

# 헤더
st.markdown("""
<div style="background: rgba(255, 255, 255, 0.8); backdrop-filter: blur(12px); border-bottom: 1px solid rgba(156, 163, 175, 0.2); padding: 1rem; margin-bottom: 2rem; border-radius: 0 0 12px 12px;">
    <div style="display: flex; align-items: center; justify-content: space-between; max-width: 1200px; margin: 0 auto;">
        <div style="display: flex; align-items: center; gap: 12px;">
            <div style="background: #C8A96A; color: white; width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 14px;">
                💍
            </div>
            <span style="font-weight: bold; font-size: 24px; color: #92400E;">MarryRoute</span>
            <span style="background: rgba(255, 255, 255, 0.8); border: 1px solid rgba(217, 119, 6, 0.2); border-radius: 12px; padding: 4px 8px; font-size: 12px; display: flex; align-items: center; gap: 4px;">
                ✨ 마리
            </span>
        </div>
    </div>
</div>
""", unsafe_allow_html=True)

# 네비게이션
col1, col2, col3, col4, col5 = st.columns(5)

with col1:
    if st.button("💬 마리", key="nav_chat", use_container_width=True):
        st.session_state.current_view = 'chat'

with col2:
    if st.button("📅 일정", key="nav_timeline", use_container_width=True):
        st.session_state.current_view = 'timeline'

with col3:
    if st.button("🏠 홈", key="nav_home", use_container_width=True):
        st.session_state.current_view = 'home'

with col4:
    if st.button("🔍 찾기", key="nav_search", use_container_width=True):
        st.session_state.current_view = 'search'

with col5:
    if st.button("💰 예산", key="nav_budget", use_container_width=True):
        st.session_state.current_view = 'budget'

# 메인 컨텐츠
if st.session_state.current_view == 'home':
    # 홈 화면
    st.markdown('<div class="hero-card">', unsafe_allow_html=True)
    
    col1, col2 = st.columns([2, 1])
    
    with col1:
        st.markdown("""
        <div style="position: relative;">
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 1rem;">
                <div style="background: #C8A96A; color: white; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                    ✨
                </div>
                <span style="font-size: 24px; font-weight: bold;">마리</span>
                <span style="background: rgba(255, 255, 255, 0.8); border: 1px solid rgba(217, 119, 6, 0.2); border-radius: 12px; padding: 4px 12px; font-size: 14px;">AI 플래너</span>
            </div>
            
            <h1 style="font-size: 36px; font-weight: bold; margin-bottom: 12px; color: #92400E;">
                결혼 준비, <span style="color: #C8A96A;">가장 스마트한 방법</span>
            </h1>
            <p style="font-size: 18px; margin-bottom: 24px; color: #B45309;">
                AI가 분석한 맞춤 추천으로 시간과 비용을 절약하세요
            </p>
        </div>
        """, unsafe_allow_html=True)
        
        # 통계 카드들
        stat_cols = st.columns(4)
        stats = [
            {"icon": "🎯", "label": "맞춤 추천", "value": "TOP 3", "color": "#C8A96A"},
            {"icon": "📈", "label": "평균 절약", "value": "460만원", "color": "#23C19C"},
            {"icon": "⏰", "label": "시간 단축", "value": "85%", "color": "#FF6B6B"},
            {"icon": "🛡️", "label": "만족도", "value": "96%", "color": "#845EC2"}
        ]
        
        for i, stat in enumerate(stats):
            with stat_cols[i]:
                st.markdown(f"""
                <div class="stat-card">
                    <div style="font-size: 40px; margin-bottom: 12px;">{stat['icon']}</div>
                    <div style="font-size: 20px; font-weight: bold; margin-bottom: 4px; color: {stat['color']};">{stat['value']}</div>
                    <div style="font-size: 14px; font-weight: 500; color: #B45309;">{stat['label']}</div>
                </div>
                """, unsafe_allow_html=True)

    st.markdown('</div>', unsafe_allow_html=True)
    
    # 마리에게 물어보기 버튼
    if st.button("💬 마리에게 물어보기", key="main_chat_btn", use_container_width=True):
        st.session_state.current_view = 'chat'
        st.rerun()
    
    st.markdown("""
    <div style="text-align: center; font-size: 20px; font-weight: bold; margin: 2rem 0; color: #92400E;">
        AI 웨딩 플래너와 1:1 무료 상담
    </div>
    """, unsafe_allow_html=True)
    
    # 빠른 액션 버튼들
    col1, col2 = st.columns(2)
    with col1:
        if st.button("🧮 예산 계산기", use_container_width=True):
            st.session_state.current_view = 'budget'
            st.rerun()
    with col2:
        if st.button("🎯 업체 추천받기", use_container_width=True):
            st.session_state.current_view = 'search'
            st.rerun()
    
    # 현황 카드들
    st.markdown("### 📊 현재 진행 상황")
    
    col1, col2, col3 = st.columns(3)
    
    with col1:
        st.markdown("""
        <div class="vendor-card">
            <div style="display: flex; align-items: center; justify-content: between; margin-bottom: 16px;">
                <h4 style="margin: 0; color: #92400E;">예산 현황</h4>
                <span style="opacity: 0.6;">📊</span>
            </div>
            <div style="font-size: 24px; font-weight: bold; margin-bottom: 8px;">4,350만원 <span style="font-size: 14px; font-weight: normal; opacity: 0.6;">/ 5,000만원</span></div>
            <div class="budget-progress">
                <div style="background: #C8A96A; height: 100%; width: 87%;"></div>
            </div>
            <div style="font-size: 14px; color: #059669;">650만원 여유</div>
        </div>
        """, unsafe_allow_html=True)
    
    with col2:
        st.markdown("""
        <div class="vendor-card">
            <div style="display: flex; align-items: center; justify-content: between; margin-bottom: 16px;">
                <h4 style="margin: 0; color: #92400E;">진행률</h4>
                <span style="opacity: 0.6;">📈</span>
            </div>
            <div style="font-size: 24px; font-weight: bold; margin-bottom: 8px;">60% <span style="font-size: 14px; font-weight: normal; opacity: 0.6;">완료</span></div>
            <div class="budget-progress">
                <div style="background: #059669; height: 100%; width: 60%;"></div>
            </div>
            <div style="font-size: 14px; color: #059669;">순조롭게 진행중</div>
        </div>
        """, unsafe_allow_html=True)
    
    with col3:
        st.markdown("""
        <div class="vendor-card">
            <div style="display: flex; align-items: center; justify-content: between; margin-bottom: 16px;">
                <h4 style="margin: 0; color: #92400E;">D-Day</h4>
                <span style="opacity: 0.6;">📅</span>
            </div>
            <div style="font-size: 24px; font-weight: bold; margin-bottom: 8px;">126일 <span style="font-size: 14px; font-weight: normal; opacity: 0.6;">남음</span></div>
            <div style="font-size: 14px; opacity: 0.6; margin-bottom: 8px;">2025년 7월 15일</div>
            <div style="font-size: 14px; color: #2563EB;">다음 일정: 드레스 피팅</div>
        </div>
        """, unsafe_allow_html=True)

elif st.session_state.current_view == 'search':
    # 업체 검색 화면
    st.markdown("## 🎯 AI 추천 업체")
    
    # 검색 및 필터
    col1, col2 = st.columns([3, 1])
    with col1:
        search_query = st.text_input("", placeholder="업체명이나 지역으로 검색...", key="search_input")
    with col2:
        st.button("🔍 필터", use_container_width=True)
    
    # 업체 카드들
    for i, vendor in enumerate(vendors):
        st.markdown(f"""
        <div class="vendor-card">
            <div style="display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 16px;">
                <div style="font-size: 32px;">{vendor['image']}</div>
                <div style="background: #FEF7E0; color: #C8A96A; border-radius: 12px; padding: 4px 8px; font-size: 12px; font-weight: 500;">
                    TOP {i + 1}
                </div>
            </div>
            
            <h4 style="font-weight: bold; font-size: 18px; margin-bottom: 4px; color: #92400E;">{vendor['name']}</h4>
            <p style="font-size: 14px; margin-bottom: 12px; color: #B45309;">{vendor['description']}</p>
            
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 12px;">
                <span style="color: #EAB308;">⭐</span>
                <span style="font-size: 14px; font-weight: 500;">{vendor['rating']}</span>
                <span style="font-size: 12px; color: #B45309;">({vendor['reviews']} 리뷰)</span>
            </div>
            
            <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 16px;">
                <span style="font-weight: bold; font-size: 18px; color: #92400E;">{vendor['price']}</span>
                <span style="font-size: 14px; color: #059669;">{vendor['savings']}</span>
            </div>
            
            <div style="display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 16px;">
                {' '.join([f'<span style="font-size: 12px; padding: 4px 8px; border-radius: 12px; background: rgba(255, 255, 255, 0.8); border: 1px solid rgba(217, 119, 6, 0.2);">{perk}</span>' for perk in vendor['perks'][:2]])}
            </div>
        </div>
        """, unsafe_allow_html=True)
        
        col1, col2 = st.columns([4, 1])
        with col1:
            st.button(f"상세보기 - {vendor['name']}", key=f"detail_{vendor['id']}", use_container_width=True)
        with col2:
            st.button("❤️", key=f"like_{vendor['id']}")

elif st.session_state.current_view == 'timeline':
    # 타임라인 화면
    st.markdown("## 📅 결혼 준비 타임라인")
    
    for i, item in enumerate(timeline_items):
        status_color = "#059669" if item['status'] == 'completed' else "#C8A96A" if item['status'] == 'upcoming' else "#9CA3AF"
        status_text = "완료" if item['status'] == 'completed' else "진행중" if item['status'] == 'upcoming' else "예정"
        status_icon = "✅" if item['status'] == 'completed' else "⏰"
        
        st.markdown(f"""
        <div class="timeline-item">
            <div style="display: flex; align-items: center; gap: 16px;">
                <div style="width: 48px; height: 48px; border-radius: 50%; background: {status_color}; color: white; display: flex; align-items: center; justify-content: center; font-size: 20px;">
                    {status_icon}
                </div>
                
                <div style="flex: 1;">
                    <h4 style="font-weight: 600; font-size: 18px; margin-bottom: 4px; color: #92400E;">{item['title']}</h4>
                    <p style="color: #B45309; margin-bottom: 0;">{item['date']}</p>
                </div>
                
                <div style="background: {status_color}; color: white; border-radius: 12px; padding: 4px 12px; font-size: 14px; font-weight: 500;">
                    {status_text}
                </div>
            </div>
        </div>
        """, unsafe_allow_html=True)
        
        if item['status'] == 'upcoming':
            col1, col2 = st.columns(2)
            with col1:
                st.button("진행하기", key=f"proceed_{item['id']}")
            with col2:
                st.button("일정 변경", key=f"reschedule_{item['id']}")

elif st.session_state.current_view == 'budget':
    # 예산 관리 화면
    st.markdown("## 💰 예산 관리")
    
    st.markdown("""
    <div class="vendor-card">
        <h3 style="font-size: 18px; font-weight: 600; margin-bottom: 16px; color: #92400E;">전체 예산 현황</h3>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 24px;">
            <div>
                <div style="font-size: 30px; font-weight: bold; margin-bottom: 8px; color: #92400E;">4,350만원</div>
                <div style="color: #B45309;">총 사용액</div>
            </div>
            <div>
                <div style="font-size: 30px; font-weight: bold; margin-bottom: 8px; color: #059669;">650만원</div>
                <div style="color: #B45309;">잔여 예산</div>
            </div>
        </div>
    </div>
    """, unsafe_allow_html=True)
    
    for category in budget_categories:
        percentage = (category['spent'] / category['budget']) * 100
        
        st.markdown(f"""
        <div style="margin-bottom: 16px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                <span style="font-weight: 500; color: #92400E;">{category['name']}</span>
                <span style="font-size: 14px; color: #B45309;">
                    {category['spent']}만원 / {category['budget']}만원
                </span>
            </div>
            <div class="budget-progress">
                <div style="background: {category['color']}; height: 100%; width: {min(percentage, 100)}%;"></div>
            </div>
        </div>
        """, unsafe_allow_html=True)
        
        if percentage > 90:
            st.warning(f"⚠️ {category['name']} 예산 초과 위험")

elif st.session_state.current_view == 'chat':
    # 채팅 화면
    st.markdown("## 💬 마리와 상담")
    
    # 채팅 헤더
    st.markdown("""
    <div style="background: rgba(255, 255, 255, 0.9); border-radius: 16px; padding: 20px; margin-bottom: 16px; border-bottom: 1px solid rgba(156, 163, 175, 0.2);">
        <div style="display: flex; align-items: center; gap: 16px;">
            <div style="position: relative;">
                <div style="width: 48px; height: 48px; border-radius: 50%; background: #C8A96A; color: white; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);">
                    ✨
                </div>
                <div style="position: absolute; bottom: -4px; right: -4px; width: 16px; height: 16px; background: #059669; border-radius: 50%; border: 2px solid white;"></div>
            </div>
            <div style="flex: 1;">
                <div style="font-weight: bold; font-size: 18px; color: #92400E;">마리</div>
                <div style="font-size: 14px; color: #B45309; display: flex; align-items: center; gap: 8px;">
                    <div style="width: 8px; height: 8px; background: #059669; border-radius: 50%;"></div>
                    AI 웨딩 플래너 • 실시간 상담
                </div>
            </div>
        </div>
    </div>
    """, unsafe_allow_html=True)
    
    # 채팅 메시지 표시
    chat_container = st.container()
    with chat_container:
        for message in st.session_state.chat_messages:
            with st.chat_message(message["role"]):
                st.write(message["content"])
                
                if message["role"] == "assistant":
                    # 빠른 액션 버튼들
                    col1, col2, col3 = st.columns(3)
                    with col1:
                        if st.button("👍 도움됨", key=f"helpful_{len(st.session_state.chat_messages)}"):
                            pass
                    with col2:
                        if st.button("📝 더 알아보기", key=f"more_{len(st.session_state.chat_messages)}"):
                            pass
                    with col3:
                        if st.button("🔄 다시 물어보기", key=f"retry_{len(st.session_state.chat_messages)}"):
                            pass
    
    # 빠른 액션 버튼들
    st.markdown("**빠른 질문:**")
    quick_actions = ['예산 상담', '업체 추천', '일정 조정', '계약서 검토', '꿀팁 공유']
    
    cols = st.columns(len(quick_actions))
    for i, action in enumerate(quick_actions):
        with cols[i]:
            if st.button(action, key=f"quick_{action}"):
                # 사용자 메시지 추가
                st.session_state.chat_messages.append({"role": "user", "content": action})
                
                # AI 응답 생성
                responses = [
                    f'{action}에 대해 자세히 설명해드릴게요! 어떤 부분이 가장 궁금하신가요?',
                    '네, 그 부분 도와드릴게요! 예산과 선호도를 알려주시면 더 정확한 추천을 해드릴 수 있어요.',
                    '좋은 선택이에요! 해당 업체의 상세 정보와 리뷰를 확인해보시겠어요?',
                    '이런 점도 고려해보세요: 계약 조건, 취소 정책, 추가 비용 등을 꼼꼼히 확인하시는 것이 좋아요.',
                    '현재 진행 상황을 체크해드릴게요. 다음 단계는 이렇게 진행하시면 됩니다!'
                ]
                
                ai_response = random.choice(responses)
                st.session_state.chat_messages.append({"role": "assistant", "content": ai_response})
                st.rerun()
    
    # 채팅 입력
    if prompt := st.chat_input("마리에게 궁금한 것을 물어보세요..."):
        # 사용자 메시지 추가
        st.session_state.chat_messages.append({"role": "user", "content": prompt})
        
        with st.chat_message("user"):
            st.write(prompt)
        
        # AI 응답 생성
        with st.chat_message("assistant"):
            with st.spinner("마리가 답변을 준비하고 있어요..."):
                time.sleep(1)  # 실제 AI 응답 시뮬레이션
                
                responses = [
                    '네, 그 부분 도와드릴게요! 예산과 선호도를 알려주시면 더 정확한 추천을 해드릴 수 있어요.',
                    '좋은 선택이에요! 해당 업체의 상세 정보와 리뷰를 확인해보시겠어요?',
                    '이런 점도 고려해보세요: 계약 조건, 취소 정책, 추가 비용 등을 꼼꼼히 확인하시는 것이 좋아요.',
                    '현재 진행 상황을 체크해드릴게요. 다음 단계는 이렇게 진행하시면 됩니다!',
                    '그 부분에 대해 더 자세한 정보를 찾아보겠습니다. 잠시만 기다려주세요!'
                ]
                
                response = random.choice(responses)
                st.write(response)
                
                # 응답을 세션 상태에 저장
                st.session_state.chat_messages.append({"role": "assistant", "content": response})
    
    # 면책 조항
    st.markdown("""
    <div style="margin-top: 16px; text-align: center; font-size: 12px; color: #9CA3AF;">
        마리는 AI로, 실제 계약 전 전문가 상담을 권장합니다
    </div>
    """, unsafe_allow_html=True)

# 푸터
st.markdown("""
<div style="margin-top: 4rem; padding: 2rem; text-align: center; color: #9CA3AF; background: rgba(255, 255, 255, 0.5); border-radius: 12px;">
    <p style="margin: 0;">© 2025 MarryRoute. AI 웨딩 플래너로 스마트한 결혼 준비를 시작하세요.</p>
</div>
""", unsafe_allow_html=True)