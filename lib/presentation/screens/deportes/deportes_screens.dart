import 'package:flutter/material.dart';

const cards =<Map<String,dynamic>>[
  {'elevation': 0.0, 'label':'Baloncesto' },
  {'elevation': 1.0, 'label':'Futboll' },
  {'elevation': 2.0, 'label':'Voleybol' },
  {'elevation': 3.0, 'label':'Tenis ' },
  {'elevation': 4.0, 'label':'Micro' },
  {'elevation': 5.0, 'label':'Rugbi' },
 
];


class DeportesScreen extends StatelessWidget {
  const DeportesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deportes Screen'),
      ),
      body: const _CardsView(),
    );
  }
}

class _CardsView extends StatelessWidget {
  const _CardsView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
      
          ...cards.map(
            (card)=>_CardType4( elevation: card['elevation'], label:card['label'] ),
          ),
          


          const SizedBox(height: 50,)
        ],
      ),
    );
  }
}

class _CardType4 extends StatelessWidget {
  
  final String label;
  final double elevation;

  const _CardType4({

    required this.label,
    required this.elevation

  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation:elevation,      
      child: Stack(
        children: [
      
          Image.network(
            'https://picsum.photos/id/73/400/150',
            height: 150,
            fit:BoxFit.cover,
          ),
      
          Align(
            alignment: Alignment.topRight ,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.only(bottomLeft:Radius.circular(20) )
              ),
              child: IconButton(
                icon:Icon(Icons.more_vert_outlined),
                onPressed: (){},
                 ),
            )
          ),
      
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.only(bottomLeft:Radius.circular(60) )
              ),
            child: Text(label),
            ),
            )
          
        ],
       ),
    );
  }
}