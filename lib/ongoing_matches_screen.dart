import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/tennis_live_score_screen.dart';
import 'package:flutter/material.dart';

class OngoingMatches extends StatefulWidget {
  const OngoingMatches({super.key});

  @override
  State<OngoingMatches> createState() => _OngoingMatchesState();
}

class _OngoingMatchesState extends State<OngoingMatches> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ongoing matches"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tennis').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            return ListView.separated(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];

                return ListTile(
                  title: Text(doc.get('name')),
                  subtitle: Text(doc.id),
                  trailing: const Icon(Icons.arrow_circle_right_outlined),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TennisLiveScoreScreen(docId: doc.id,)));
                  },
                );
              },
              separatorBuilder: (_, __) => const Divider(),
            );
          }),
    );
  }
}
