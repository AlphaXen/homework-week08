import 'package:myapp/week08/calendar_scheduler/component/main_calendar.dart';
import 'package:flutter/material.dart';
import 'package:myapp/week08/calendar_scheduler/component/schedule_card.dart';
import 'package:myapp/week08/calendar_scheduler/component/today_banner.dart';
import 'package:myapp/week08/calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:myapp/week08/calendar_scheduler/const/color.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/week08/calendar_scheduler/database/drift_database.dart';
import 'package:myapp/week08/calendar_scheduler/provider/schedule_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  DateTime selectedDate = DateTime.utc(
    // 선택된 날짜를 관리할 변수
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {

    // 프로바이더 변경이 있을 때마다 build() 함수 재실행
    final provider = context.watch<ScheduleProvider>();

    // 선택된 날짜 가져오기
    final selectedDate = provider.selectedDate;

    // 선택된 날짜에 해당되는 일정들 가져오기
    final schedules = provider.cache[selectedDate] ?? [];
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        // 새 일정 버튼
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            // BottomSheet 열기
            context: context,
            isDismissible: true, // 배경 탭했을 때 BottomSheet 닫기
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate, // 선택된 날짜 (selectedDate) 넘겨주기
            ),
            // BottomSheet의 높이를 화면의 최대 높이로
            // 정의하고 스크롤 가능하게 변경
            isScrollControlled: true,
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        // 시스템 UI 피해서 UI 구현하기
        child: Column(
          // 달력과 리스트를 세로로 배치
          children: [
            // 미리 작업해둔 달력 위젯 보여주기
            MainCalendar(
              selectedDate: selectedDate, // 선택된 날짜 전달하기
              // 날짜가 선택되었을 때 실행할 함수
              onDaySelected: (selectedDate,focusedDate) => onDaySelected(selectedDate, focusedDate, context),
            ),
            SizedBox(height: 8.0),
            SizedBox(height: 8.0),

            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index){
                  final schedule = schedules[index];

                  return Dismissible(
                    key: ObjectKey(schedule.id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (DismissDirection direction) {
                      provider.deleteSchedule(date: selectedDate, id: schedule.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0),
                        child: ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          content: schedule.content,
                        ),
                      ),
                    );
                },
              ),
            ),
            
            TodayBanner(
              // 배너 추가하기
              selectedDate: selectedDate,
              count: schedules.length,
            ),
            SizedBox(height: 8.0),
            ScheduleCard(
              // 구현해둔 일정 카드
              startTime: 12,
              endTime: 14,
              content: '프로그래밍 공부',
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
  }
}
