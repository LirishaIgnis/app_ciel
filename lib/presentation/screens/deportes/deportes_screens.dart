import 'package:app_ciel/config/menu/menu_sports.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';




class DeportesScreens extends StatelessWidget {
  const DeportesScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Deportes'),
        
      ),
      body: const _HomeView(),
     
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    //Text('nombre'); Basico

    return ListView.builder(
      itemCount: appSportItems.length,
      itemBuilder: (context, index) {
        final sportItem = appSportItems[index];

        return _CustomListTile(sportItem: sportItem);
      },
    );
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.sportItem,
  });

  final SportItems sportItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(sportItem.icon, color: colors.primary),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: colors.primary),
      title: Text(sportItem.title),
      subtitle: Text(sportItem.subTitle),
      onTap: () {
        context.push(sportItem.link);
      },
    );
  }
}