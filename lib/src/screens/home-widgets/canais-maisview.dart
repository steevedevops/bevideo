import 'package:bestapp_package/bestapp_package.dart';
import 'package:bevideo/config.dart';
import 'package:bevideo/src/controllers/canais-controller.dart';
import 'package:flutter/material.dart';

class CanaisMaisView extends ConsumerWidget {
  const CanaisMaisView({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context, watch) {
    final futureInfocanais = watch(canaisMaisProvider);
    return SliverToBoxAdapter(
      child: futureInfocanais.when(
        data: (canaisList) => Container(
          height: 75,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: canaisList.length,
            itemBuilder: (context, index){
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300],
                  ),
                  child: BeImageCached(
                    url: "${Config.BASE_URL}${canaisList[index].capa}",
                    sizeIcon: 50,
                    placeholder: beloadCircular(color: Theme.of(context).accentColor),
                  ),
                ),
              );
            },
          )
        ), 
        loading: ()=>  Container(
          height: 75,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: BeShimmer(
            linearGradient: ShimmerGradient,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index){
                return BeShimmerLoading(
                  isLoading: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[300],
                      ),
                      child: Text('loading...'),
                    ),
                  ),
                );
              },
            ),
          ),
        ), 
        error: (e, stack) => Text('$e')
      )
    );
  }
}