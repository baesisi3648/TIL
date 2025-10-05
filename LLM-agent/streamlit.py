import streamlit as st
import time
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from datetime import datetime, timedelta

# 페이지 설정
st.set_page_config(
    page_title="MarryRoute - AI 웨딩 플래너",
    page_icon="💍",
    layout="wide",
    initial_sidebar_state="collapsed"
)

# 커스텀 CSS
st.markdown("""
<style>
    /* 전체 배경 */
    .main {
        background: linear-gradient(to bottom right, #fffbf0, #ffffff, #fef7e6);
        color: #92400e;
    }
    
    /* 헤더 스타일 */
    .header {
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        padding: 1rem 2rem;
        border-bottom: 1px solid rgba(0,0,0,0.1);
        margin-bottom: 2rem;
        border-radius: 15px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }
    
    /* 카드 스타일 */
    .card {
        background: rgba(255, 255, 255, 0.9);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(200, 169, 106, 0.3);
        border-radius: 20px;
        padding: 2rem;
        margin: 1rem 0;
        box-shadow: 0 8px 32px rgba(0,0,0,0.1);
    }
    
    /* 채팅 메시지 스타일 */
    .chat-message {
        padding: 1rem;
        margin: 0.5rem 0;
        border-radius: 20px;
        max-width: 80%;
    }
    
    .user-message {
        background: linear-gradient(to bottom right, #374151, #1f2937);
        color: white;
        margin-left: auto;
        text-align: right;
    }
    
    .bot-message {
        background: #f5f1e8;
        color: #374151;
        border: 1px solid #e8dcc8;
    }
    
    /* 버튼 스타일 */
    .stButton > button {
        background: linear-gradient(135deg, #d4af37, #b8860b);
        color: #92400e;
        border: none;
        border-radius: 15px;
        padding: 0.75rem 2rem;
        font-weight: bold;
        transition: all 0.3s ease;
    }
    
    .stButton > button:hover {
        transform: scale(1.05);
        box-shadow: 0 4px 20px rgba(212, 175, 55, 0.3);
    }
    
    /* 네비게이션 스타일 */
    .nav-container {
        position: fixed;
        bottom: 0;
        left: 0;
        right: 0;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        border-top: 1px solid rgba(0,0,0,0.1);
        padding: 1rem;
        z-index: 1000;
    }
    
    /* 통계 카드 */
    .stat-card {
        background: rgba(255, 255, 255, 0.8);
        border-radius: 15px;
        padding: 1.5rem;
        text-align: center;
        margin: 0.5rem;
        transition: all 0.3s ease;
        border: 1px solid rgba(200, 169, 106, 0.2);
    }
    
    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
    }
    
    /* 진행률 바 */
    .progress-bar {
        background: #e5e7eb;
        border-radius: 10px;
        height: 8px;
        overflow: hidden;
        margin: 0.5rem 0;
    }
    
    .progress-fill {
        height: 100%;
        border-radius: 10px;
        transition: width 1s ease;
    }
    
    /* 업체 카드 */
    .vendor-card {
        background: rgba(255, 255, 255, 0.9);
        border: 1px solid rgba(200, 169, 106, 0.3);
        border-radius: 20px;
        padding: 1.5rem;
        margin: 1rem 0;
        transition: all 0.3s ease;
    }
    
    .vendor-card:hover {
        transform: scale(1.02);
        box-shadow: 0 10px 40px rgba(0,0,0,0.15);
    }
    
    /* 타임라인 아이템 */
    .timeline-item {
        background: rgba(255, 255, 255, 0.9);
        border: 1px solid rgba(200, 169, 106, 0.3);
        border-radius: 20px;
        padding: 1.5rem;
        margin: 1rem 0;
        position: relative;
    }
    
    .timeline-completed {
        border-left: 5px solid #10b981;
    }
    
    .timeline-upcoming {
        border-left: 5px solid #c8a96a;
    }
    
    .timeline-pending {
        border-left: 5px solid #6b7280;
    }
    
    /* 숨기기 */
    .stDeployButton {display:none;}
    footer {visibility: hidden;}
    .stApp > header {visibility: hidden;}
    
    /* 사이드바 숨기기 */
    .css-1d391kg {display: none;}
    
    /* 메인 컨테이너 여백 조정 */
    .css-18e3th9 {
        padding-top: 1rem;
        padding-bottom: 5rem;
    }
</style>
""", unsafe_allow_html=True)

# 데이터 초기화
if 'vendors' not in st.session_state:
    st.session_state.vendors = [
        {
            "id": "H1001",
            "name": "호텔 루미에르",
            "type": "웨딩홀",
            "price": "2,950만원",
            "price_num": 29500000,
            "seat": "200석",
            "rating": 4.6,
            "reviews": 128,
            "perks": ["원본 제공", "주차 300대", "야간가든"],
            "emoji": "🏛️",
            "location": "강남구",
            "description": "유럽 클래식 스타일의 럭셔리 웨딩홀",
            "savings": "230만원 절약 가능"
        },
        {
            "id": "S2001",
            "name": "스튜디오 노바",
            "type": "스튜디오",
            "price": "350만원",
            "price_num": 3500000,
            "seat": "촬영 3컨셉",
            "rating": 4.8,
            "reviews": 96,
            "perks": ["원본 제공", "야외 촬영", "드레스 대여"],
            "emoji": "📸",
            "location": "성수동",
            "description": "자연광이 아름다운 감성 스튜디오",
            "savings": "80만원 절약 가능"
        },
        {
            "id": "D3001",
            "name": "아틀리에 클레르",
            "type": "드레스",
            "price": "500만원",
            "price_num": 5000000,
            "seat": "피팅 3회",
            "rating": 4.7,
            "reviews": 82,
            "perks": ["신상 라인", "수제 베일", "맞춤 수선"],
            "emoji": "👗",
            "location": "청담동",
            "description": "파리 컬렉션 브랜드 드레스 전문",
            "savings": "150만원 절약 가능"
        }
    ]

if 'timeline_items' not in st.session_state:
    st.session_state.timeline_items = [
        {"id": 1, "title": "예식장 예약", "date": "2025-03-15", "status": "completed", "category": "venue"},
        {"id": 2, "title": "드레스 피팅", "date": "2025-04-20", "status": "upcoming", "category": "dress"},
        {"id": 3, "title": "스튜디오 촬영", "date": "2025-05-10", "status": "pending", "category": "photo"},
        {"id": 4, "title": "청첩장 발송", "date": "2025-06-01", "status": "pending", "category": "invitation"},
        {"id": 5, "title": "결혼식", "date": "2025-07-15", "status": "pending", "category": "wedding"}
    ]

if 'budget_categories' not in st.session_state:
    st.session_state.budget_categories = [
        {"name": "웨딩홀", "budget": 3000, "spent": 2950, "color": "#C8A96A"},
        {"name": "스튜디오", "budget": 400, "spent": 350, "color": "#23C19C"},
        {"name": "드레스", "budget": 600, "spent": 500, "color": "#FF6B6B"},
        {"name": "메이크업", "budget": 200, "spent": 0, "color": "#845EC2"},
        {"name": "플라워", "budget": 150, "spent": 0, "color": "#FF9671"}
    ]

if 'chat_messages' not in st.session_state:
    st.session_state.chat_messages = [
        {"id": 1, "from": "bot", "content": "안녕하세요! 저는 AI 웨딩 플래너 마리예요 ✨ 어떤 도움이 필요하신가요?", "timestamp": datetime.now()}
    ]

if 'current_view' not in st.session_state:
    st.session_state.current_view = 'chat'

# 헤더
st.markdown("""
<div class="header">
    <div style="display: flex; align-items: center; justify-content: space-between;">
        <div style="display: flex; align-items: center; gap: 1rem;">
            <div style="width: 40px; height: 40px; background: #C8A96A; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white;">
                🗺️
            </div>
            <h1 style="margin: 0; font-size: 1.5rem; font-weight: bold;">MarryRoute</h1>
            <span style="background: rgba(255,255,255,0.9); border: 1px solid #e8dcc8; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.75rem; display: flex; align-items: center; gap: 0.5rem;">
                ✨ 마리
            </span>
        </div>
        <div style="display: flex; gap: 1rem;">
            <button style="background: none; border: none; padding: 0.5rem; border-radius: 10px; cursor: pointer;">🔔</button>
            <button style="background: none; border: none; padding: 0.5rem; border-radius: 10px; cursor: pointer;">⚙️</button>
        </div>
    </div>
</div>
""", unsafe_allow_html=True)

# 네비게이션
col1, col2, col3, col4, col5 = st.columns(5)

with col1:
    if st.button("💬 마리", key="nav_chat", help="AI 상담"):
        st.session_state.current_view = 'chat'

with col2:
    if st.button("📅 일정", key="nav_timeline", help="타임라인"):
        st.session_state.current_view = 'timeline'

with col3:
    if st.button("🏠 홈", key="nav_home", help="메인 대시보드"):
        st.session_state.current_view = 'home'

with col4:
    if st.button("🔍 찾기", key="nav_search", help="업체 검색"):
        st.session_state.current_view = 'search'

with col5:
    if st.button("💰 예산", key="nav_budget", help="예산 관리"):
        st.session_state.current_view = 'budget'

st.markdown("---")

# 메인 컨텐츠
if st.session_state.current_view == 'home':
    # 홈 화면
    st.markdown('<div class="card">', unsafe_allow_html=True)
    
    col1, col2 = st.columns([1, 3])
    with col1:
        st.markdown("""
        <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
            <div style="width: 50px; height: 50px; background: #C8A96A; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem;">
                ✨
            </div>
            <div>
                <h2 style="margin: 0; font-size: 1.5rem;">마리</h2>
                <span style="background: rgba(255,255,255,0.9); border: 1px solid #e8dcc8; padding: 0.25rem 0.75rem; border-radius: 10px; font-size: 0.75rem;">AI 플래너</span>
            </div>
        </div>
        """, unsafe_allow_html=True)
    
    with col2:
        st.markdown("""
        <h1 style="font-size: 2rem; margin-bottom: 0.5rem;">
            결혼 준비, <span style="color: #C8A96A;">가장 스마트한 방법</span>
        </h1>
        <p style="color: #92400e; font-size: 1.1rem; margin-bottom: 2rem;">
            AI가 분석한 맞춤 추천으로 시간과 비용을 절약하세요
        </p>
        """, unsafe_allow_html=True)
    
    # 통계 카드들
    col1, col2, col3, col4 = st.columns(4)
    
    stats = [
        {"icon": "🎯", "label": "맞춤 추천", "value": "TOP 3", "color": "#C8A96A"},
        {"icon": "📈", "label": "평균 절약", "value": "460만원", "color": "#23C19C"},
        {"icon": "⏰", "label": "시간 단축", "value": "85%", "color": "#FF6B6B"},
        {"icon": "🛡️", "label": "만족도", "value": "96%", "color": "#845EC2"}
    ]
    
    for i, (col, stat) in enumerate(zip([col1, col2, col3, col4], stats)):
        with col:
            st.markdown(f"""
            <div class="stat-card">
                <div style="font-size: 2rem; margin-bottom: 0.5rem;">{stat['icon']}</div>
                <div style="font-size: 1.5rem; font-weight: bold; color: {stat['color']}; margin-bottom: 0.25rem;">{stat['value']}</div>
                <div style="font-size: 0.9rem; color: #92400e;">{stat['label']}</div>
            </div>
            """, unsafe_allow_html=True)
    
    # 마리에게 물어보기 버튼
    st.markdown("<br>", unsafe_allow_html=True)
    if st.button("💬 마리에게 물어보기 - AI 웨딩 플래너와 1:1 무료 상담", key="chat_main"):
        st.session_state.current_view = 'chat'
        st.rerun()
    
    # 퀵 액션 버튼들
    col1, col2 = st.columns(2)
    with col1:
        st.button("🧮 예산 계산기")
    with col2:
        st.button("🎯 업체 추천받기")
    
    st.markdown('</div>', unsafe_allow_html=True)
    
    # 퀵 스탯
    col1, col2, col3 = st.columns(3)
    
    with col1:
        st.markdown("""
        <div class="card">
            <div style="display: flex; justify-content: between; align-items: center; margin-bottom: 1rem;">
                <h3>예산 현황</h3>
                <span>📊</span>
            </div>
            <div style="font-size: 1.5rem; font-weight: bold; margin-bottom: 0.5rem;">
                4,350만원 <span style="font-size: 1rem; opacity: 0.6;">/ 5,000만원</span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill" style="width: 87%; background: #C8A96A;"></div>
            </div>
            <div style="color: #10b981; font-size: 0.9rem; margin-top: 0.5rem;">650만원 여유</div>
        </div>
        """, unsafe_allow_html=True)
    
    with col2:
        st.markdown("""
        <div class="card">
            <div style="display: flex; justify-content: between; align-items: center; margin-bottom: 1rem;">
                <h3>진행률</h3>
                <span>📈</span>
            </div>
            <div style="font-size: 1.5rem; font-weight: bold; margin-bottom: 0.5rem;">
                60% <span style="font-size: 1rem; opacity: 0.6;">완료</span>
            </div>
            <div class="progress-bar">
                <div class="progress-fill" style="width: 60%; background: #10b981;"></div>
            </div>
            <div style="color: #10b981; font-size: 0.9rem; margin-top: 0.5rem;">순조롭게 진행중</div>
        </div>
        """, unsafe_allow_html=True)
    
    with col3:
        st.markdown("""
        <div class="card">
            <div style="display: flex; justify-content: between; align-items: center; margin-bottom: 1rem;">
                <h3>D-Day</h3>
                <span>📅</span>
            </div>
            <div style="font-size: 1.5rem; font-weight: bold; margin-bottom: 0.5rem;">
                126일 <span style="font-size: 1rem; opacity: 0.6;">남음</span>
            </div>
            <div style="opacity: 0.6; font-size: 0.9rem; margin-bottom: 0.5rem;">2025년 7월 15일</div>
            <div style="color: #3b82f6; font-size: 0.9rem;">다음 일정: 드레스 피팅</div>
        </div>
        """, unsafe_allow_html=True)

elif st.session_state.current_view == 'search':
    # 찾기 화면 (AI 추천 업체)
    st.markdown('<div class="card">', unsafe_allow_html=True)
    st.markdown("## 🔍 AI 추천 업체")