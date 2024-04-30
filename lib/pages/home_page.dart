import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/pages/recipe_page.dart';
import 'package:recipe_app/services/data_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _mealTypeFilter ="";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Recipe Book"),
        centerTitle: true,
      ),
      body: SafeArea(child: _buildUI()),
    );
  }

  Widget _buildUI(){
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          _recipeTypesButtons(),
          _recipesList(),


        ],
      ),
    );
  }

  Widget _recipeTypesButtons(){
    return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.05,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding:const EdgeInsets.symmetric(horizontal: 5.0),
              child: FilledButton(onPressed: (){
              setState(() {
                _mealTypeFilter = "Breakfast";
              });
              }, child: const Text("Breakfast")),
            ),
             Padding(
              padding:const EdgeInsets.symmetric(horizontal: 5.0),
              child: FilledButton(onPressed: (){
                setState(() {
                _mealTypeFilter = "Lunch";
              });
              }, child: const Text("Lunch")),
            ),
             Padding(
              padding:const EdgeInsets.symmetric(horizontal: 5.0),
              child: FilledButton(onPressed: (){
                setState(() {
                _mealTypeFilter = "Dinner";
              });
              }, child: const Text("Dinner")),
            ),
             Padding(
              padding:const EdgeInsets.symmetric(horizontal: 5.0),
              child: FilledButton(onPressed: (){
                setState(() {
                _mealTypeFilter = "Snack";
              });
              }, child: const Text("Snacks")),
            )
          ],
        ),
    );
  }

  Widget _recipesList(){
    return Expanded(child: FutureBuilder(
      future: DataService().getRecipes(_mealTypeFilter), 
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),
          );
        }
        if(snapshot.hasError){
          return const Center(child: Text("unable to load"),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context,index){
            Recipe recipe = snapshot.data! [index];
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return RecipePage(recipe: recipe,);
                  }));
              },
              contentPadding: const EdgeInsets.only(top: 20.0),
              isThreeLine: true,
              subtitle: Text("${recipe.cuisine}\nDifficulty: ${recipe.difficulty}"),
              leading: Image.network(recipe.image),
              title: Text(recipe.name),
              trailing: Text("${recipe.rating.toString()}⭐",style: TextStyle(fontSize: 15),)
              );
        },);
      }));
  }
}