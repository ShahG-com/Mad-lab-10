import 'package:flutter/material.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const FlashcardScreen(),
    );
  }
}

class Flashcard {
  final String id;
  final String question;
  final String answer;
  bool isLearned;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.isLearned = false,
  });
}

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({Key? key}) : super(key: key);

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with TickerProviderStateMixin {
  late List<Flashcard> flashcards;
  late GlobalKey<AnimatedListState> listKey;
  int nextId = 10;

  @override
  void initState() {
    super.initState();
    listKey = GlobalKey<AnimatedListState>();
    _initializeCards();
  }

  void _initializeCards() {
    flashcards = [
      Flashcard(
        id: '1',
        question: 'What is the capital of France?',
        answer: 'Paris',
      ),
      Flashcard(
        id: '2',
        question: 'What is 2 + 2?',
        answer: '4',
      ),
      Flashcard(
        id: '3',
        question: 'Who wrote Romeo and Juliet?',
        answer: 'William Shakespeare',
      ),
      Flashcard(
        id: '4',
        question: 'What is the largest planet?',
        answer: 'Jupiter',
      ),
      Flashcard(
        id: '5',
        question: 'What year did the Titanic sink?',
        answer: '1912',
      ),
      Flashcard(
        id: '6',
        question: 'What is the chemical symbol for gold?',
        answer: 'Au',
      ),
      Flashcard(
        id: '7',
        question: 'How many continents are there?',
        answer: '7',
      ),
      Flashcard(
        id: '8',
        question: 'What is the smallest prime number?',
        answer: '2',
      ),
    ];
  }

  int get learnedCount => flashcards.where((c) => c.isLearned).length;
  int get totalCount => flashcards.length;

  Future<void> _refreshCards() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _initializeCards();
      for (var card in flashcards) {
        card.isLearned = false;
      }
    });
  }

  void _markAsLearned(int index) {
    setState(() {
      flashcards[index].isLearned = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${flashcards[index].question} marked as learned!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeCard(int index) {
    final removed = flashcards[index];
    flashcards.removeAt(index);
    listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildCardItem(removed, animation, -1),
      duration: const Duration(milliseconds: 300),
    );
  }

  void _addNewCard() {
    final newCard = Flashcard(
      id: '$nextId',
      question: 'New Question $nextId?',
      answer: 'Answer $nextId',
    );
    nextId++;

    flashcards.add(newCard);
    listKey.currentState?.insertItem(
      flashcards.length - 1,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildCardItem(
      Flashcard card, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: FlashcardWidget(
        card: card,
        onLearned: index >= 0 ? () => _markAsLearned(index) : null,
        onDismiss: index >= 0 ? () => _removeCard(index) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshCards,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 140,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('Flashcard Quiz'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade400, Colors.blue.shade600],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Progress',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$learnedCount of $totalCount learned',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ElevatedButton.icon(
                  onPressed: _addNewCard,
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Card'),
                ),
              ),
            ),
            SliverAnimatedList(
              key: listKey,
              initialItemCount: flashcards.length,
              itemBuilder: (context, index, animation) {
                if (index < flashcards.length) {
                  return _buildCardItem(flashcards[index], animation, index);
                }
                return const SizedBox.shrink();
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    flashcards.isEmpty
                        ? 'No cards available'
                        : 'Keep learning!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlashcardWidget extends StatefulWidget {
  final Flashcard card;
  final VoidCallback? onLearned;
  final VoidCallback? onDismiss;

  const FlashcardWidget({
    Key? key,
    required this.card,
    this.onLearned,
    this.onDismiss,
  }) : super(key: key);

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isFlipped = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (isFlipped) {
      controller.reverse();
    } else {
      controller.forward();
    }
    setState(() => isFlipped = !isFlipped);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.card.id),
      direction: DismissDirection.horizontal,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16),
        child: const Icon(Icons.check, color: Colors.white, size: 28),
      ),
      secondaryBackground: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          widget.onLearned?.call();
        } else {
          widget.onDismiss?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GestureDetector(
          onTap: _toggleFlip,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              final angle = controller.value * 3.14159;
              final transform = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle);

              return Transform(
                alignment: Alignment.center,
                transform: transform,
                child: Container(
                  decoration: BoxDecoration(
                    color: isFlipped
                        ? Colors.green.shade50
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.card.isLearned
                          ? Colors.green
                          : Colors.blue.shade300,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.card.isLearned)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                'Learned',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      Text(
                        isFlipped ? 'Answer' : 'Question',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isFlipped
                            ? widget.card.answer
                            : widget.card.question,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tap to flip',
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}