import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:match_42/data/message.dart';
import 'package:match_42/data/user.dart';
import 'package:match_42/viewmodel/chat_viewmodel.dart';
import 'package:provider/provider.dart';

const List<String> topics = [
  '서로의 취미에 대해 얘기해보세요.',
  '본과정에서 가장 힘들었던 순간에 대해 얘기해보세요.',
  '코딩을 하며 성취감을 느꼈던 순간에 대해 얘기해보세요.',
  '코딩에 관심을 가지게 된 계기에 대해 얘기해보세요.',
  '최근 즐겨보는 유튜브나 넷플릭스 영상에 대해 얘기해보세요.',
  '클러스터 근처에서 맛있게 먹었던 메뉴에 대해 얘기해보세요.',
  '좋아하는 영화에 대해 얘기해보세요.',
  '요즘 즐겨듣는 음악에 대해 얘기해보세요.',
  '가장 힘들었던 과제에 대해 얘기해보세요.',
  '서로에게 좋았던 책 한 권씩을 추천해주세요.',
  '자신의 패션에 대해 얘기해보세요.',
  '여가시간에 주로 무엇을 하며 시간을 보내는지 얘기해보세요.',
  '최근 새로 생긴 관심사가 있다면 얘기해보세요.',
  '여행 계획이나 다녀왔던 여행에 대해 얘기해보세요.',
  '좋아하는 음식에 대해 얘기해보세요.',
  '어제 하루 어떻게 보냈는지에 대해 얘기해보세요.',
  '가장 단기적인 목표에 대해서 얘기해보세요.',
  '서로의 꿈에 대해 얘기해보세요.',
  '최근 가장 즐거웠던 순간에 대해 얘기해보세요.',
  '자신의 장점에 대해 얘기해보세요.',
  '새롭게 배워보고 싶은 분야에 대해 얘기해보세요.',
  '좋아하는 게임에 대해 얘기해보세요.',
  '끝말잇기를 해서 5번째로 나온 단어에 대해 얘기해보세요.',
  '내일의 계획에 대해 얘기해보세요.',
  '최근 만족스러웠던 소비에 대해 얘기해보세요.',
  '어릴 적 꿈에 대해 얘기해보세요.',
  '요즘 사고싶은 물건에 대해 얘기해보세요.',
  '로또 1등에 당첨된다면 무엇을 하고싶은지 얘기해보세요.',
  '노년에 어떤 삶을 살고싶은지 얘기해보세요.',
  '서로의 버킷리스트에 대해 얘기해보세요.',
  '최근 하고있는 고민에 대해 얘기해보세요.',
  '요즘 나를 즐겁게 해주는 것들에 대해 얘기해보세요.',
];

class MakeTopic extends StatelessWidget {
  const MakeTopic({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    ChatViewModel viewModel = context.read();
    return Dialog(
      elevation: 0,
      child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: colorScheme.primary,
          ),
          child: TextButton(
            onPressed: () {
              int index =
                  Random(DateTime.now().millisecond).nextInt(topics.length);
              viewModel.sendSystem(topics[index]);
              context.pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.primary,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              // fixedSize: Size.fromHeight(18),
            ),
            child: Text(
              '랜덤 대화주제 생성하기',
              style: TextStyle(
                color: colorScheme.onPrimary.withAlpha(240),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
