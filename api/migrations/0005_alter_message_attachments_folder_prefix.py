# Generated by Django 4.0.6 on 2022-07-14 11:56

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0004_remove_message_attachments_key_prefix_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='message',
            name='attachments_folder_prefix',
            field=models.CharField(blank=True, default=None, max_length=1024, null=True),
        ),
    ]
