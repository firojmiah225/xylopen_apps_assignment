import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/presentation/screen/home/provider/media_provider.dart';
import 'package:taskapp/presentation/screen/home/widget/player_controller.dart';
import 'package:taskapp/presentation/screen/home/widget/song_list_item.dart';

import '../../../core/contains/app_colors.dart';
import '../../../core/contains/app_strings.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
      ),
      body: Column(
        children: [
          PlayerController(),
          Expanded(
            child: Consumer<MediaProvider>(
              builder: (context, provider, child) {
                final playlist = provider.playlist;
                return ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final song = playlist[index];

                    final isSelected = index == provider.currentIndex;

                    return SongListItem(
                      song: song,
                      index: index,
                      isPlaying: provider.isPlaying,
                      isSelected: isSelected,
                      onTap: () {
                        provider.playSongAtIndex(index);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}