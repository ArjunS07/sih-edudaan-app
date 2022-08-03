# Generated by Django 4.1 on 2022-08-03 16:11

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_remove_zoommeeting_is_started'),
    ]

    operations = [
        migrations.CreateModel(
            name='Message',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('time_sent', models.DateTimeField(auto_created=True, auto_now_add=True)),
                ('text', models.CharField(max_length=128, null=True)),
                ('sender_uuid', models.CharField(max_length=64)),
                ('tutorship', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='api.tutorship')),
            ],
        ),
    ]
