import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/chat_message.dart';
import '../services/ai_assistant_service.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendQuery(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    AiAssistantService.instance.sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListenableBuilder(
          listenable: AiAssistantService.instance,
          builder: (context, _) {
            final messages = AiAssistantService.instance.messages;
            final isChatActive = messages.isNotEmpty;

            return Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: isChatActive
                      ? _buildChatList(messages)
                      : _buildWelcomeState(),
                ),
                _buildBottomControls(),
                const SizedBox(height: 90), // Space for floating bottom nav bar
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final dailyUsed = AiAssistantService.instance.dailyUsed;
    final dailyLimit = AiAssistantService.instance.dailyLimit;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            color: Colors.white,
            iconSize: 26,
            onPressed: () {},
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                color: AppColors.cyan,
                size: 22,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'D-Plan AI',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Yapay zekâ asistanın',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2E47),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF2C3E5E),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Bugün $dailyUsed/$dailyLimit',
                  style: const TextStyle(
                    color: Color(0xFFCBD5E1),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                color: Colors.white,
                iconSize: 24,
                onPressed: () {
                  AiAssistantService.instance.clearChat();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 10,
        bottom: 12,
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildHeroIcon(),
          const SizedBox(height: 18),
          const Text(
            'D-Plan AI',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Yapay zekâ asistanın',
            style: TextStyle(
              color: AppColors.cyan,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Gününüzü planlamama, görevlerinizi\ndüzenlememe ve üretkenliğinizi artırmama hazır\nmısınız?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.5,
                height: 1.45,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 28),
          _buildWelcomePromptOptions(),
        ],
      ),
    );
  }

  Widget _buildHeroIcon() {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1C283F),
        border: Border.all(
          color: const Color(0xFF283A5D),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withAlpha(25),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.auto_awesome,
          color: AppColors.cyan,
          size: 40,
        ),
      ),
    );
  }

  Widget _buildWelcomePromptOptions() {
    final prompts = [
      'Bugünümü saat saat planla',
      'Hafta sonu için alışveriş listesi oluştur',
      'Su içme alışkanlığı ekle — günde 2500 ml',
      'Bu haftaki verimliliğimi analiz et',
    ];

    return Column(
      children: prompts.map((prompt) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _sendQuery(prompt),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF172033),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF263550),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_circle_right_outlined,
                    color: AppColors.cyan,
                    size: 22,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      prompt,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChatList(List<ChatMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        if (message.sender == MessageSender.user) {
          return _buildUserBubble(message.text);
        } else if (message.sender == MessageSender.status) {
          return _buildStatusIndicator(message.text);
        } else {
          return _buildAiBubble(message.text);
        }
      },
    );
  }

  Widget _buildUserBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 40),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF38BDF8),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1E2E47),
              border: Border.all(
                color: const Color(0xFF2C3E5E),
                width: 1,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: AppColors.cyan,
                size: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'D-Plan AI',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.cyan,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiBubble(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1E2E47),
                  border: Border.all(
                    color: const Color(0xFF2C3E5E),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    color: AppColors.cyan,
                    size: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'D-Plan AI',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF182236),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF263550),
                width: 1.2,
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    final hourlyRemaining = AiAssistantService.instance.hourlyRemaining;

    return Column(
      children: [
        // Quota remaining notification row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 13,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 6),
              Text(
                'Bu saat $hourlyRemaining hakkın kaldı',
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Horizontal scrollable quick suggestion chips
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildQuickChip(
                label: '➕ Görev ekle',
                onTap: () => _sendQuery('Görev ekle'),
              ),
              const SizedBox(width: 8),
              _buildQuickChip(
                label: '📊 Günün analizini yap',
                onTap: () => _sendQuery('Günün analizini yap'),
              ),
              const SizedBox(width: 8),
              _buildQuickChip(
                label: '⏱️ 15 dk odaklanma',
                onTap: () => _sendQuery('15 dk odaklanma'),
              ),
              const SizedBox(width: 8),
              _buildQuickChip(
                label: '🎯 Haftalık özet',
                onTap: () => _sendQuery('Haftalık özet'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Text input field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2338),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: const Color(0xFF283652),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: _sendQuery,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    cursorColor: AppColors.cyan,
                    decoration: const InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      hintStyle: TextStyle(
                        color: AppColors.textHint,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _sendQuery(_textController.text),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      color: AppColors.cyan,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickChip({
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1B2438),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF283652),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
