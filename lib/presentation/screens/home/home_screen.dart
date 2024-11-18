import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_ciel/config/menu/menu_items.dart';
//import 'package:widgets_app/presentation/widgets/side_menu.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const _HomeView(),
      //drawer:  SideMenu(scaffoldKey: scaffoldKey),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    //Text('nombre'); Basico

    return ListView.builder(
      itemCount: appMenuItems.length,
      itemBuilder: (context, index) {
        final menuItem = appMenuItems[index];

        return _CustomListTile(menuItem: menuItem);
      },
    );
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.menuItem,
  });

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(menuItem.icon, color: colors.primary),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: colors.primary),
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subTitle),
      onTap: () {
        // Estruturas basica para navegar entre pantallas mediante link.

        //Link directo
        //Navigator.of(context).push(
        // MaterialPageRoute(
        //builder: (context)=> const ConfiguracionScreen(),
        // ),
        //);

        //Link con dirreciones desde el main
        //Navigator.pushNamed(context, menuItem.link);

        context.push(menuItem.link);
      },
    );
  }
}